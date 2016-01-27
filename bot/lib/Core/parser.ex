defmodule Core.Parser do
  alias Core.Model.User
  alias Core.Model.Chat
  alias Core.Model.Message
  alias Core.Model.PhotoSize
  alias Core.Model.Audio
  alias Core.Model.Document
  alias Core.Model.Sticker
  alias Core.Model.Video
  alias Core.Model.Voice
  alias Core.Model.Contact
  alias Core.Model.Location
  alias Core.Model.Update
  alias Core.Model.UserProfilePhotos
  alias Core.Model.File

  def parse_result(result, method) do
    case method do
      "getMe" -> parse(User, result)
      "sendChatAction" -> result
      "getUserProfilePhotos" -> parse(UserProfilePhotos, result)
      "getUpdates" -> parse(:updates, result)
      "setWebhook" -> result
      "getFile" -> parse(File, result)
      _ -> parse(Message, result)
    end
  end

  @keys_of_message [:message, :reply_to_message]
  @keys_of_photo [:photo, :new_chat_photo]
  @keys_of_user [:from, :forward_from, :new_chat_participant, :left_chat_participant]

  defp parse(:photo, l) when is_list(l), do: Enum.map(l, &(parse(PhotoSize, &1)))
  defp parse(:photos, l) when is_list(l), do: Enum.map(l, &(parse(:photo, &1)))
  defp parse(:updates, l) when is_list(l), do: Enum.map(l, &(parse(Update, &1)))
  defp parse(type, val), do: struct(type, Enum.map(val, &(parse(&1))))
  defp parse({:chat, val}), do: {:chat, parse(Chat, val)}
  defp parse({:audio, val}), do: {:audio, parse(Audio, val)}
  defp parse({:video, val}), do: {:video, parse(Video, val)}
  defp parse({:voice, val}), do: {:voice, parse(Voice, val)}
  defp parse({:sticker, val}), do: {:sticker, parse(Sticker, val)}
  defp parse({:document, val}), do: {:document, parse(Document, val)}
  defp parse({:contact, val}), do: {:contact, parse(Contact, val)}
  defp parse({:location, val}), do: {:location, parse(Location, val)}
  defp parse({:thumb, val}), do: {:thumb, parse(PhotoSize, val)}
  defp parse({:photos, val}), do: {:photos, parse(:photos, val)}
  defp parse({key, val}) when key in @keys_of_photo, do: {key, parse(:photo, val)}
  defp parse({key, val}) when key in @keys_of_user, do: {key, parse(User, val)}
  defp parse({key, val}) when key in @keys_of_message, do: {key, parse(Message, val)}
  defp parse(others), do: others
end