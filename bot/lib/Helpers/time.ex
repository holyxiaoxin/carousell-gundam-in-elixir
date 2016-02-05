defmodule Bot.Time do
  use Timex

  def time_ago(time_created) when is_binary(time_created) do
    DateFormat.parse!(time_created, "{ISOz}")
    |> Date.diff(Date.now, :timestamp)
    |> TimeFormat.format(:humanized)
    |> Kernel.<>(" ago")
    |> String.replace(" seconds", "sec")
    |> String.replace(" minutes", "min")
  end
end
