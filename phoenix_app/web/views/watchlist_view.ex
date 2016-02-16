defmodule PhoenixApp.WatchlistView do
  use PhoenixApp.Web, :view

  def render("index.json", %{watchlists: watchlists}) do
    %{data: render_many(watchlists, PhoenixApp.WatchlistView, "watchlist.json")}
  end

  def render("show.json", %{watchlist: watchlist}) do
    %{data: render_one(watchlist, PhoenixApp.WatchlistView, "watchlist.json")}
  end

  def render("watchlist.json", %{watchlist: watchlist}) do
    %{id: watchlist.id,
      chat_id: watchlist.chat_id}
  end
end
