use Mix.Config

config :bench, Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "benchmarkdbuser",
  password: "benchmarkdbpass",
  database: "hello_world",
  hostname: "localhost",
  pool_size: 64,
  log: false
