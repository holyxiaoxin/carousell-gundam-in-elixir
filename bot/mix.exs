defmodule Bot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bot,
      version: "0.0.1",
      elixir: "~> 1.2",
      escript: [main_module: Bot],
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      default_task: "bot.run"
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :logger,
        :nadia,
        :httpoison, :poison,
        :tzdata
      ]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:nadia, git: "https://github.com/zhyu/nadia"},
     {:httpoison, "~> 0.8.0"},
     {:poison, "~> 1.5.0"},
     # tzdata crash at startup in escript
     # https://github.com/bitwalker/timex/issues/86
     {:tzdata, "== 0.1.8", override: true},
     #
     {:timex, git: "https://github.com/bitwalker/timex"}
    ]
  end
end
