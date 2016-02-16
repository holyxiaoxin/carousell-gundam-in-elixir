defmodule PhoenixApp.WatchlistControllerTest do
  use PhoenixApp.ConnCase

  alias PhoenixApp.Watchlist
  @valid_attrs %{chat_id: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, watchlist_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    watchlist = Repo.insert! %Watchlist{}
    conn = get conn, watchlist_path(conn, :show, watchlist)
    assert json_response(conn, 200)["data"] == %{"id" => watchlist.id,
      "chat_id" => watchlist.chat_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, watchlist_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, watchlist_path(conn, :create), watchlist: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Watchlist, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, watchlist_path(conn, :create), watchlist: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    watchlist = Repo.insert! %Watchlist{}
    conn = put conn, watchlist_path(conn, :update, watchlist), watchlist: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Watchlist, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    watchlist = Repo.insert! %Watchlist{}
    conn = put conn, watchlist_path(conn, :update, watchlist), watchlist: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    watchlist = Repo.insert! %Watchlist{}
    conn = delete conn, watchlist_path(conn, :delete, watchlist)
    assert response(conn, 204)
    refute Repo.get(Watchlist, watchlist.id)
  end
end
