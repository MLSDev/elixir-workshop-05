defmodule HolidayAppWeb.Plugs.AuthorizeTest do
  @behaviour Bodyguard.Policy

  use HolidayAppWeb.ConnCase

  alias HolidayAppWeb.Plugs.Authorize

  describe "map_action(controller_action)" do
    test "maps RESTful controller actions to policy actions" do
      assert :create == Authorize.map_action(:new)
      assert :create == Authorize.map_action(:create)

      assert :index == Authorize.map_action(:index)

      assert :show == Authorize.map_action(:show)

      assert :update == Authorize.map_action(:edit)
      assert :update == Authorize.map_action(:update)

      assert :delete == Authorize.map_action(:delete)
    end

    test "maps non-RESTful controller actions to same-named policy actions" do
      assert :execute == Authorize.map_action(:execute)
    end
  end

  describe "fetch_action(controller_action, plug_opts)" do
    test "if action_map passed, try to find policy action there" do
      action_map = %{block_user: :block}
      assert :block == Authorize.fetch_action(:block_user, %{action_map: action_map})
    end

    test "if not found in action_map, try to map controller action using map_action()" do
      action_map = %{block_user: :block}
      assert :index == Authorize.fetch_action(:index, %{action_map: action_map})
      assert :execute == Authorize.fetch_action(:execute, %{action_map: action_map})
    end

    test "if action_map not passed, falling back to map_action()" do
      assert :index == Authorize.fetch_action(:index, %{})
      assert :execute == Authorize.fetch_action(:execute, %{})
    end
  end

  describe "fetch_user(conn, plug_opts)" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, conn: conn, user: user}
    end

    test "defaults to nil (e.g. if not logged in)", %{conn: conn} do
      plug_opts = %{}
      assert nil == Authorize.fetch_user(conn, plug_opts)
    end

    test "tries to fetch from conn.assigns", %{user: user} do
      conn = build_conn_and_login(user) |> get("/")

      plug_opts = %{}
      assert user.id == Authorize.fetch_user(conn, plug_opts).id
    end

    test "calls given 1-arity function to fetch user", %{conn: conn, user: user} do
      user_fun = fn _ -> user end
      plug_opts = %{user: user_fun}
      assert user == Authorize.fetch_user(conn, plug_opts)
    end
  end

  describe "fetch_params(conn, plug_opts)" do
    test "returns empty keyword list if no params_fun passed", %{conn: conn} do
      assert [] == Authorize.fetch_params(conn, %{})
    end

    test "calls passed params_fun and returns result", %{conn: conn} do
      params_fun = fn _conn, _params -> %{one: 1, two: 2} end
      
      result = Authorize.fetch_params(conn, %{params_fun: params_fun})

      assert %{two: 2, one: 1} == result
    end
  end

  describe "init()" do
    test "fallback defaults to HolidayAppWeb.FallbackController" do
      opts = Authorize.init([])
      assert opts.fallback == HolidayAppWeb.FallbackController
    end

    test "action_fun defaults to Phoenix.Controller.action_name/1" do
      opts = Authorize.init([])
      assert opts.action_fun == &(Phoenix.Controller.action_name/1)
    end
  end

  describe "call() performs authorization" do
    def authorize(:update, %{is_admin: true}, _params), do: :ok
    def authorize(_, _, _), do: {:error, :unauthorized}

    defmodule DummyFallbackController do
      def call(conn, {:error, :unauthorized}) do
        conn |> put_status(:forbidden)
      end
    end

    setup %{conn: conn} do
      plug_opts = %{
        policy: __MODULE__,
        action_fun: fn _ -> :update end,
        user: fn _ -> %{is_admin: false} end,
        params_fun: fn _, _ -> %{} end,
        fallback: DummyFallbackController
      }

      {:ok, %{conn: conn, plug_opts: plug_opts}}
    end

    test "permits authorized user ", %{conn: conn, plug_opts: plug_opts} do
      plug_opts = %{plug_opts | user: fn _ -> %{is_admin: true} end}

      conn = Authorize.call(conn, plug_opts)

      refute conn.halted
    end

    test "rejects unauthorized user, halts connection", %{conn: conn, plug_opts: plug_opts} do
      conn = Authorize.call(conn, plug_opts)

      assert conn.halted
      assert conn.status == 403
    end
  end
end
