defmodule HolidayAppWeb.ErrorViewTest do
  use HolidayAppWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 400.html" do
    assert render_to_string(HolidayAppWeb.ErrorView, "400.html", []) ==
           "Bad Request"
  end

  test "renders 404.html" do
    assert render_to_string(HolidayAppWeb.ErrorView, "404.html", []) ==
           "Not Found"
  end

  test "render 500.html" do
    assert render_to_string(HolidayAppWeb.ErrorView, "500.html", []) ==
           "Internal Server Error"
  end

  test "render any other" do
    assert render_to_string(HolidayAppWeb.ErrorView, "505.html", []) ==
           "Internal Server Error"
  end
end
