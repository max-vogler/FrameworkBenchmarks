defmodule Main do
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    plug_config = Application.get_env(:bench, Http)
    children    = [
      Plug.Adapters.Cowboy.child_spec(:http, Http, [], plug_config),
      worker(Repo, []),
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end


end
