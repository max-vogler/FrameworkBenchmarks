defmodule Main do
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Router, [], [port: 8080]),
      worker(Repo, []),
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end


end
