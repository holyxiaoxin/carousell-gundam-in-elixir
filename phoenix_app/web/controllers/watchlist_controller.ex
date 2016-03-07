defmodule PhoenixApp.WatchlistController do
  use PhoenixApp.Web, :controller

  alias PhoenixApp.Watchlist

  plug :scrub_params, "watchlist" when action in [:create, :update]

  def index(conn, _params) do
    watchlists = Repo.all(Watchlist)
    render(conn, "index.json", watchlists: watchlists)
  end

  def create(conn, %{"watchlist" => watchlist_params}) do
    changeset = Watchlist.changeset(%Watchlist{}, watchlist_params)

    case Repo.insert(changeset) do
      {:ok, watchlist} ->
        conn
        |> put_status(:created)
        |> render("show.json", watchlist: watchlist)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixApp.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def list(conn, %{"chat_id" => chat_id}) do
    query = from p in Watchlist, where: p.chat_id == ^chat_id
    watchlists = Repo.all(query)
    render(conn, "index.json", watchlists: watchlists)
  end

  def show(conn, %{"id" => id}) do
    watchlist = Repo.get!(Watchlist, id)
    render(conn, "show.json", watchlist: watchlist)
  end

  def update(conn, %{"id" => id, "watchlist" => watchlist_params}) do
    watchlist = Repo.get!(Watchlist, id)
    changeset = Watchlist.changeset(watchlist, watchlist_params)

    case Repo.update(changeset) do
      {:ok, watchlist} ->
        render(conn, "show.json", watchlist: watchlist)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PhoenixApp.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "chat_id" => chat_id}) do
    watchlist = Repo.get(Watchlist, id)

    if watchlist && chat_id == watchlist.chat_id do
      Repo.delete!(watchlist)
    end
    conn |> json(%{status: "ok"})
  end
end
