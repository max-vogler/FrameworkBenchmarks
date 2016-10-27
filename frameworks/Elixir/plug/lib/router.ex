defmodule Router do
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
    send_json(conn, Repo.get_random(World))
  end

  get "/queries/:q" do
    db = Repo.get_postgres_conn()
    select = World.prepare_select(db)
    results = for _ <- 1..coerce_queries(q) do
      [[id, rand]] = Postgrex.execute!(db, select, [rand()]).rows
      %World{id: id, randomnumber: rand}
    end
    send_json(conn, results)
  end

  get "/fortunes" do
    new = %Fortune{id: 0, message: "Additional fortune added at request time."}
    fortunes =
      [new | Repo.all(Fortune)]
      |> Enum.sort(fn f1, f2 -> f1.message < f2.message end)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, make_fortunes_html(fortunes))
  end

  get "/updates/:q" do
    db = Repo.get_postgres_conn()
    select = World.prepare_select(db)
    update_batch = World.prepare_batch_update(db)

    tuples =
      for _ <- 1..coerce_queries(q) do
        id = rand()
        _old_rand = Postgrex.execute!(db, select, [id])
        {id, rand()}
      end
    structs = Enum.map(tuples, fn {id, r} -> %World{id: id, randomnumber: r} end)
    Postgrex.execute!(db, update_batch, Enum.unzip(tuples) |> Tuple.to_list())

    send_json(conn, structs)
  end

  def send_json(conn, data) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(data))
  end

  def coerce_queries(queries) do
    case Integer.parse(queries) do
      {x, ""} when x >= 500 -> 500
      {x, ""} when x >=   1 -> x
      _                     -> 1
    end
  end

  def rand(), do: :rand.uniform(10000)

  EEx.function_from_file(:def, :make_fortunes_html, "lib/templates/fortunes.eex", [:fortunes])
end
