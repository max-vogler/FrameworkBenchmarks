defmodule Hello.Mixfile do
  use Mix.Project

  def project do
    [app: :bench,
     version: "0.1.0",
     elixir: "~> 1.3",
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
     {:html_entities, "~> 0.3"},
    ]
  end
end
