defmodule Bot do

  def main(_args) do
    IO.puts "starting...."
    Bot.Updater.loop(0)
  end

end
