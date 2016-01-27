defmodule Bot do
  alias Nadia.Model.Update
  alias Nadia.Model.Message
  # alias Nadia.Model.Chat

  def main(_args) do
    IO.puts "starting...."
    loop(0)
  end

  defp loop(update_id) do
    Nadia.get_updates(timeout: 5, offset: update_id)
    |> case do
      {:ok, [h|t]} ->
        %Update{message: %Message{text: text}, update_id: update_id} = h
        update_id = update_id + 1
        process_message(%{text: text})
      {:ok, []} ->
        IO.puts "no updates"
      {:error, _} ->
        IO.puts "error"
    end
    loop(update_id)
  end

  defp process_message(%{text: text}) do
    IO.puts text
  end
end
