use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :holiday_app, HolidayAppWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

# Finally import the config/test.secret.exs
# which should be versioned separately.
import_config "test.secret.exs"
