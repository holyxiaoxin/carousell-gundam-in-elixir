defmodule Core.Api do
  alias Core.Model.Error
  alias Core.Model.Update
  alias Core.Parser

  # CONSTANTS
  @base_url "https://api.telegram.org/bot"
  @path_get_me "/getMe"
  @path_get_updates "/getUpdates"

  defp token, do: System.get_env("EXS_CADAM_BOT_TOKEN")
  defp build_url(method), do: @base_url <> token <> "/" <> method

  def get_updates(update_id) do
    HTTPoison.start
    formatted_response = (@base_url <> token <> @path_get_updates)
    |> HTTPoison.get!([], [params: %{timeout: 10, offset: update_id}, recv_timeout: 20000])
    |> process_response("getUpdates")
    case formatted_response do
      {:ok, l} ->
        if l == [] do
          %{update_id: update_id}
        else
          %Update{update_id: update_id} = List.last(l)
          %Update{message: message} = List.first(l)
          update_id = update_id + 1
          %{first_message_in_queue: message, update_id: update_id}
        end
      {:error, _} ->
        %{update_id: update_id}
    end

  end

  # def request(method) do
  #   HTTPoison.start
  #   build_url(method)
  #   |> HTTPoison.get!
  # end

  defp process_response(response, method) do
    case response do
      %HTTPoison.Response{status_code: 200, body: body} ->
        case Poison.decode!(body, keys: :atoms) do
          %{ok: false, description: description} -> {:error, %Error{reason: description}}
          %{result: true} -> :ok
          %{result: result} -> {:ok, Parser.parse_result(result, method)}
        end
      %HTTPoison.Response{body: body} -> {:error, %Error{reason: body}}
      %HTTPoison.Error{reason: reason} -> {:error, %Error{reason: reason}}
    end
  end
end
