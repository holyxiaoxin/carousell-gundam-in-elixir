defmodule Bot do
  def main(_args) do
    IO.puts "starting...."
    IO.inspect Nadia.get_updates(timeout: 8)
  end
end
