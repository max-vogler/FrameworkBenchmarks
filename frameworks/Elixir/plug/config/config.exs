use Mix.Config

config :bench, Repo,
  adapter:   Ecto.Adapters.Postgres,
  username:  "benchmarkdbuser",
  password:  "benchmarkdbpass",
  database:  "hello_world",
  hostname:  "localhost",
  pool_size: 256

config :bench, Http,
  acceptors: 256,
  max_connections: 32_768,
  port: 8080

config :logger, level: :error
