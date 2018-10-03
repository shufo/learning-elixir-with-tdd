use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_api_101, PhoenixApi101Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenix_api_101, PhoenixApi101.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "root",
  database: "phoenix_api_101_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
