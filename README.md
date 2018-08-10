# HolidayApp

Internal MLSDev Elixir Workshop #05 - Authorization


## Up and running

* Clone project
* `mix deps.get`
* Setup `.env` with auth providers credentials (see `.env.example` for reference)
* Setup `config/*.exs` files (pay attention to secret config examples)
* `mix ecto.setup` # create, migrate and seed database
* `mix test`
* `source .env`
* `iex -S mix phx.server`
* Open [http://localhost:4000](http://localhost:4000) in your browser


## Docs

* `mix docs`
* `open doc/index.html`


## Coverage

* `mix test --cover`

HTML output:
* `mix coveralls.html`
* `open cover/excoveralls.html`


## Seeds

Check `priv/repo/seeds.exs` file


## Commits and branches

* Initial commit
  - Copy of last commit of the [previous](https://github.com/MLSDev/elixir-workshop-04) Elixir Workshop

* [**is_admin**](https://github.com/MLSDev/elixir-workshop-05/tree/is_admin) branch
  - Simple authorization with `is_admin` flag in `User` schema

* [**bodyguard**](https://github.com/MLSDev/elixir-workshop-05/tree/bodyguard) branch
  - Authorization using [Bodyguard](https://hexdocs.pm/bodyguard) package

* [**roles**](https://github.com/MLSDev/elixir-workshop-05/tree/roles) branch
  - Role-based authorization
  - Data migration example (from `is_admin` to `role`)
