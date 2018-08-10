defmodule HolidayAppWeb.Router do
  use HolidayAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HolidayAppWeb.AuthPipeline
  end

  pipeline :auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", HolidayAppWeb do
    pipe_through :browser

    get "/", HomeController, :index
  end

  scope "/auth", HolidayAppWeb do
    pipe_through :browser

    get "/new", AuthController, :new
    get "/:provider", AuthController, :request
    post "/identity/callback", AuthController, :callback
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", HolidayAppWeb do
    pipe_through [:browser, :auth]

    delete "/auth/logout", AuthController, :logout
    resources "/holidays", HolidayController
    resources "/users", UserController, except: [:delete]
  end

  scope "/admin", HolidayAppWeb do
    pipe_through [:browser, :auth, HolidayAppWeb.Plugs.EnsureAdmin]
  end
end
