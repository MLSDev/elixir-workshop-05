defmodule HolidayAppWeb.FallbackControllerTest do
  use HolidayAppWeb.ConnCase

  alias HolidayAppWeb.FallbackController

  describe "400" do
    test "sets 400 response code and renders `bad request` page", %{conn: conn} do
      conn = FallbackController.call(conn, {:error, :bad_request})
      assert conn.status == 400
      assert conn.resp_body =~ "Bad Request"
    end
  end

  describe "404" do
    test "sets 404 response code and renders `not found` page", %{conn: conn} do
      conn = FallbackController.call(conn, {:error, :not_found})
      assert conn.status == 404
      assert conn.resp_body =~ "Not Found"
    end
  end
end
