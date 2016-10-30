defmodule Hello.Mixfile do
  use Mix.Project

  def project do
    [app: :bench,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [mod: {Main, []},
     applications: [:cowboy, :plug, :ecto, :postgrex]]
  end

  defp deps do
    [{:cowboy, "~> 1.0"},
     {:plug, "~> 1.0"},
     {:poison, "~> 2.0"},
     {:ecto, "~> 2.0"},
     {:postgrex, "~> 0.12"},
     {:phoenix_html, "~> 2.7"},
    ]
  end
end
