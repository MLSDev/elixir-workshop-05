use Mix.Config

# Use mix phx.gen.secret
config :holiday_app, HolidayAppWeb.Endpoint,
  secret_key_base: "your-secret-key-base"

# Configure your database
config :holiday_app, HolidayApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "your-username",
  password: "your-password",
  database: "holiday_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure Guadrian implementation module
# Use mix guardian.gen.secret
config :holiday_app, HolidayAppWeb.Guardian,
  issuer: "holiday_app",
  secret_key: "your-guardian-secret" # put the result of the mix command above here
