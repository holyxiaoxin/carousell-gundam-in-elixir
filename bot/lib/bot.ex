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
          IO.puts "recent"
          carousell_uri = "https://carousell.com/ui/iso/api;path=%2Fproducts%2Fsearch%2F;query=%7B%22count%22%3A"<>"1"<>"%2C%22start%22%3A0%2C%22sort%22%3A%22recent%22%2C%22query%22%3A%22gundam%22%7D"
          HTTPoison.start
          case HTTPoison.get(carousell_uri) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
              %{result: %{products: products}} = Poison.decode!(body, keys: :atoms)
              bot_reply = ""
              for p <- products do
                %{title: title, price: price, id: id, time_created: time_created} = p
                bot_reply = bot_reply <> "[Title]: " <> title <> "\n"
                bot_reply = bot_reply <> "[Price]: " <> price <> "\n"
                bot_reply = bot_reply <> "[URL]: https://carousell.com/p/"<> Integer.to_string(id) <> "\n"
                bot_reply = bot_reply <> "[Time Created]: " <> time_created
                IO.inspect DateFormat.Parser.parse(time_created, "{ISOz}")

                Nadia.send_message(chat_id, bot_reply)
              end
            {:ok, %HTTPoison.Response{status_code: 404}} ->
              IO.puts "Not found :("
            {:error, %HTTPoison.Error{reason: reason}} ->
              IO.inspect reason
          end
        _ ->
          IO.puts "something else"
      end
    else # normal text

    end
  end
end
