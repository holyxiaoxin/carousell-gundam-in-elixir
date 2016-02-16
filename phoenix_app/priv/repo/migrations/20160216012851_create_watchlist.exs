defmodule PhoenixApp.Repo.Migrations.CreateWatchlist do
  use Ecto.Migration

  def change do
    create table(:watchlists) do
      add :chat_id, :string

      timestamps
    end

  end
end
