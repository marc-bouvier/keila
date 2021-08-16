defmodule Keila.MixProject do
  use Mix.Project

  def project do
    [
      app: :keila,
      version: "0.6.1",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      name: "Keila",
      homepage_url: "https://keila.io",
      docs: docs()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Keila.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies settings for ex_doc
  defp docs do
    [
      main: "Keila",
      extras: ["README.md"],
      groups_for_modules: [
        Auth: [~r/^Keila.Auth/]
      ]
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.6"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto,
       git: "https://github.com/elixir-ecto/ecto.git",
       ref: "3d2ad6b7401d3e784162d8973159bb109cba3d9e",
       override: true},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.15"},
      {:floki, "~> 0.31.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:swoosh, "~> 1.3"},
      {:gen_smtp, "~> 1.1"},
      {:hackney, "~> 1.9"},
      {:hashids, "~> 2.0"},
      {:argon2_elixir, "~> 2.3"},
      {:httpoison, "~> 1.8"},
      {:nimble_csv, "~> 1.1"},
      {:oban, "~> 2.7.2"},
      {:solid, "~> 0.8.1"},
      {:earmark, "~> 1.4"},
      {:tzdata, "~> 1.1"},
      {:ex_aws, "~> 2.2.3"},
      {:sweet_xml, "~> 0.6"},
      {:ex_aws_ses, git: "https://github.com/pentacent/ex_aws_ses"},
      {:php_serializer, "~> 2.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
