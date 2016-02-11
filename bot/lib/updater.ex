defmodule Bot.Updater do
  alias Nadia.Model.Update
  alias Nadia.Model.Message
  alias Nadia.Model.Chat
  alias Bot.Model.CarousellProduct

  defp carousell_uri(search_count) when is_integer(search_count) do
    "https://carousell.com/ui/iso/api;path=%2Fproducts%2Fsearch%2F;query=%7B%22count%22%3A"
    <>Integer.to_string(search_count)
    <>"%2C%22start%22%3A0%2C%22sort%22%3A%22recent%22%2C%22query%22%3A%22gundam%22%7D"
  end

  def loop(update_id) do
    Nadia.get_updates(timeout: 5, offset: update_id)
    |> case do
      {:ok, [h|_t]} ->
        %Update{message: %Message{text: text, chat: %Chat{id: chat_id}}, update_id: update_id} = h
        update_id = update_id + 1
        process_message(%{text: text, chat_id: chat_id})
      {:ok, []} ->
        IO.puts "no updates"
      {:error, _} ->
        IO.puts "error"
    end
    loop(update_id)
  end

  defp process_message(%{text: text, chat_id: chat_id}) do
    if Regex.match?(~r/\//, text) do # starts with "/"
      case text do
        "/recent" <> _ ->
          IO.puts "get recent"
          case HTTPoison.get(carousell_uri(3)) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
              %{result: %{products: products}} = Poison.decode!(body, keys: :atoms)
              bot_reply = Enum.reduce(Enum.with_index(products), "",
                fn({p, index}, acc) ->
                  struct_p =  struct(CarousellProduct, p)
                  Bot.Parse.reduce_recent_reply(%{
                    acc: acc, index: Integer.to_string(index+1),
                    title: struct_p.title, price: struct_p.price,
                    p_id: Integer.to_string(struct_p.id),
                    time_created: Bot.Time.time_ago(struct_p.time_created)
                  })
                end
              )
              Nadia.send_message(chat_id, bot_reply)
            {:ok, %HTTPoison.Response{status_code: 404}} ->
              IO.puts "Not found :("
            {:error, %HTTPoison.Error{reason: reason}} ->
              IO.inspect ["error: ", reason]
          end
        _ ->
          IO.puts "something else"
      end
    else # normal text

    end
  end

end
