use Mix.Config

# Configure your database
config :holiday_app, HolidayApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "your-username",
  password: "your-password",
  database: "holiday_app_dev",
  hostname: "localhost",
  pool_size: 10

# Configure Guadrian implementation module
# Use mix guardian.gen.secret
config :holiday_app, HolidayAppWeb.Guardian,
  issuer: "holiday_app",
  secret_key: "your-guardian-secret" # put the result of the mix command above here
