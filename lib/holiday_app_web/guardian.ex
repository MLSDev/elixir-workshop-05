defmodule HolidayAppWeb.Guardian do
  use Guardian, otp_app: :holiday_app

  def subject_for_token(%{id: id} = _resource, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id} = _claims) do
    resource = HolidayApp.Users.get_user!(id)
    {:ok,  resource}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
