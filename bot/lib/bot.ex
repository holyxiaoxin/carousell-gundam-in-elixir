defmodule Bot do

  def main(_args) do
    IO.puts "starting...."
    HTTPoison.start # Starts HTTPoison and its dependencies
    Bot.Updater.loop(0)
  end

end
