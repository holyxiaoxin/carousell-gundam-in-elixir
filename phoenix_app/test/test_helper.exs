ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PhoenixApp.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PhoenixApp.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(PhoenixApp.Repo)

