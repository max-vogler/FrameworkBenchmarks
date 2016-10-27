defmodule Repo do
  use Ecto.Repo, otp_app: :bench

  def get_random(module), do: get(module, :rand.uniform(10000))

  def get_postgres_conn() do
    {:ok, conn} = Postgrex.start_link(Application.get_env(:bench, Repo))
    conn
  end
end
