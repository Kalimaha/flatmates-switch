use Mix.Config

config :switch, SwitchWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :switch, Switch.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "switch_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
