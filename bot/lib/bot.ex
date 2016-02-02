####### API ##############
# comments_count
# currency_symbol
# description
# id
# like_status
# likes_count
# location
# location_address
# location_name
# marketplace
# price
# price_formatted
# primary_photo
# primary_photo_url
# seller
# status
# time_created
# title
# user_state
# utc_last_liked
###########################

use Timex

defmodule Bot do
  alias Nadia.Model.Update
  alias Nadia.Model.Message
  alias Nadia.Model.Chat

  # defp @carousell_uri(search_count), do: "https://carousell.com/ui/iso/api;path=%2Fproducts%2Fsearch%2F;query=%7B%22count%22%3A" <> search_count <> "%2C%22start%22%3A0%2C%22sort%22%3A%22recent%22%2C%22query%22%3A%22gundam%22%7D"


  def main(_args) do
    IO.puts "starting...."
    loop(0)
  end

  defp loop(update_id) do
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
          carousell_uri = "https://carousell.com/ui/iso/api;path=%2Fproducts%2Fsearch%2F;query=%7B%22count%22%3A"<>"1"<>"%2C%22start%22%3A0%2C%22sort%22%3A%22recent%22%2C%22query%22%3A%22gundam%22%7D"
          HTTPoison.start
          case HTTPoison.get(carousell_uri) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
              %{result: %{products: products}} = Poison.decode!(body, keys: :atoms)
              bot_reply = ""

              for {p, index} <- Enum.with_index(products) do
                %{title: title, price: price, id: id, time_created: time_created} = p
                time_ago =
                  DateFormat.parse!(time_created, "{ISOz}")
                  |> Date.diff(Date.now, :timestamp)
                  |> TimeFormat.format(:humanized)
                  |> Kernel.<>(" ago")
                  |> String.replace(" seconds", "sec")
                  |> String.replace(" minutes", "min")
                bot_reply =
                  IO.iodata_to_binary([bot_reply, Integer.to_string(index+1), ":\n",
                                      "[Title]: ", title, "\n",
                                      "[Price]: ", price, "\n",
                                      "[URL]: https://carousell.com/p/", Integer.to_string(id), "\n",
                                      "[Time Created]: ", time_ago, "\n"])
                # Nadia.send_message(chat_id, bot_reply)
              end
                # TODO: Can't seem to get bot_reply scoped
                IO.inspect Nadia.send_message(chat_id, bot_reply)
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
