defmodule PhoenixApp.Repo.Migrations.CreateWatchlist do
  use Ecto.Migration

  def change do
    create table(:watchlists) do
      add :chat_id, :string
      add :listing, :string

      timestamps
    end

  end
end
