# My chat_id: 117534969
defmodule Mix.Tasks.Bot.Run do
  use Mix.Task

  @telegram_bot_api "https://api.telegram.org/bot"
  @token System.get_env("EXS_CADAM_BOT_TOKEN")

  @shortdoc "Run bot"

  def run(_) do
    IO.puts "Starting task..."
    HTTPoison.start
    uri = @telegram_bot_api <> @token <> "/getMe"
    IO.inspect HTTPoison.get! uri
  end
end
