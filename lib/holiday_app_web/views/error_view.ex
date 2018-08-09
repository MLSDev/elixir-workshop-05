defmodule HolidayAppWeb.ErrorView do
  use HolidayAppWeb, :view

  def render("400.html", _assigns) do
    "Bad Request"
  end

  def render("404.html", _assigns) do
    "Not Found"
  end

  def render("500.html", _assigns) do
    "Internal Server Error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
