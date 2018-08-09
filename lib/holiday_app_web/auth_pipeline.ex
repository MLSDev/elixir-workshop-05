defmodule HolidayAppWeb.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :holiday_app,
    error_handler: HolidayAppWeb.AuthController,
    module: HolidayAppWeb.Guardian

  plug Guardian.Plug.VerifySession # use VerifyHeader for APIs
  plug Guardian.Plug.LoadResource, allow_blank: true
  plug HolidayAppWeb.Plugs.FetchCurrentUser
end
