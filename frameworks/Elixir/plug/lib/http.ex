defmodule Http do
  use Plug.Router
  require EEx

  plug :match
  plug :dispatch

  get "/plaintext" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello, world!")
  end

  get "/json" do
    send_json(conn, %{message: "Hello, world!"})
  end

  get "/db" do
    send_json(conn, Repo.get(World, rand()))
  end

  get "/queries/:q" do
    results = for _ <- 1..coerce_queries(q), do: Repo.get(World, rand())
    send_json(conn, results)
  end

  get "/fortune" do
    new = %{id: 0, message: "Additional fortune added at request time."}
    {:safe, html} =
      [new | Repo.all(Fortune)]
      |> Enum.sort(fn f1, f2 -> f1.message < f2.message end)
      |> fortunes_html()

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, html)
  end

  get "/update/:q" do
    results = for _ <- 1..coerce_queries(q) do
      Repo.get(World, rand())
      |> World.changeset(%{randomnumber: rand()})
      |> Repo.update!()
    end
    send_json(conn, results)
  end

  def send_json(conn, data) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode_to_iodata!(data))
  end

  def coerce_queries(queries) do
    case Integer.parse(queries) do
      {x, ""} when x >= 500 -> 500
      {x, ""} when x >=   1 -> x
      _                     -> 1
    end
  end

  def rand(), do: :rand.uniform(10000)

  EEx.function_from_file(
    :def,
    :fortunes_html,
    "lib/templates/fortunes.eex",
    [:fortunes],
    engine: Phoenix.HTML.Engine
  )
end
