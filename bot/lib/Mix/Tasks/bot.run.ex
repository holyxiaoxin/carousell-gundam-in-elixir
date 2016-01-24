# My chat_id: 117534969
defmodule Mix.Tasks.Bot.Run do
  @shortdoc "Run bot"
  use Mix.Task

  alias Core.Api
  alias Core.Model.Error
  alias Core.Model.Message
  alias Core.Model.Chat

  def process_message(message) do
    %Message{text: text, chat: %Chat{id: chat_id}} = message
    # IO. inspect chat_id
    # IO.inspect text
  end

  def loop(update_id) do
    Api.get_updates(update_id)
    |> case do
      %{first_message_in_queue: message, update_id: update_id} ->
        process_message(message)
        update_id = update_id
      %{update_id: update_id} ->
        IO.puts "no message/ error"
    end
    loop(update_id)
  end

  def run(_) do
    IO.puts "Starting task..."
    loop(0)
  end

end
