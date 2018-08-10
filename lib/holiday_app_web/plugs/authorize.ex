defmodule HolidayAppWeb.Plugs.Authorize do
  @moduledoc """
  Plug that performs authorization in controllers.

  ## Options
  * `policy` *required* - the policy (or context) module

  * `action_map` - map used to determine policy action from controller action.
    If policy action can not be found in map, falls back to `map_action/1`.

  * `action_fun` - a 1-arity function which accepts the connection and
    returns action to pass to the authorization callbacks.
    If omitted, uses Phoenix Controller's `action_name(conn)`

  * `user` - a 1-arity function which accepts the connection and returns a user.
    If omitted, tries to get `current_user` from `conn.assigns`.
    If `current_user` can not be found in `conn.assigns`, defaults `user` to `nil`

  * `params_fun` - 2-arity function which accepts `conn` and request `params`
    and returns params to pass to the authorization callbacks. If omitted,
    passes empty keyword list to authorization callbacks.

  * `fallback` - a fallback controller or plug to handle authorization
    failure. The plug is called and then the pipeline is `halt`ed.
    If not specified, defaults to HolidayAppWeb.FallbackController.

  ## Examples
      plug Authorize,
        policy: JobPolicy,
        action_map: %{list: :index, running: :index},
        params_fun: &(__MODULE__.fetch_params/2)

      plug HolidayAppWeb.Authorize,
        policy: UserPolicy,
        params_fun: &(__MODULE__.fetch_params/2)

      def fetch_params(_conn, %{"user_id" => user_id}) do
        user = Users.get_user!(user_id)
        %{user: user}
      end
      def fetch_params(_, _), do: %{}
  """

  import Plug.Conn, only: [halt: 1]
  import Phoenix.Controller, only: [action_name: 1]

  @default_fallback_controller HolidayAppWeb.FallbackController

  @doc """
  Inits the plug with given options.
  """
  def init(opts \\ []) do
    %{
      policy:     Keyword.get(opts, :policy),
      action_map: Keyword.get(opts, :action_map, nil),
      action_fun: Keyword.get(opts, :action_fun, &action_name/1),
      user:       Keyword.get(opts, :user, nil),
      params_fun: Keyword.get(opts, :params_fun, nil),
      fallback:   Keyword.get(opts, :fallback, @default_fallback_controller)
    }
  end

  @doc """
  Performs authorization.
  """
  def call(conn, opts) do
    controller_action = opts.action_fun.(conn)

    permission = Bodyguard.permit(
      opts.policy,
      fetch_action(controller_action, opts),
      fetch_user(conn, opts),
      fetch_params(conn, opts)
    )

    case permission do
      :ok -> conn
      error ->
        conn
        |> opts.fallback.call(error)
        |> halt()
    end
  end

  @doc false
  def fetch_params(conn, %{params_fun: params_fun}) when is_function(params_fun, 2) do
    params_fun.(conn, conn.params)
  end
  def fetch_params(_conn, _plug_opts), do: []

  @doc false
  def fetch_action(controller_action, %{action_map: %{} = action_map}) do
    case policy_action = action_map[controller_action] do
      nil ->
        map_action(controller_action)
      _ ->
        policy_action
    end
  end

  def fetch_action(controller_action, _plug_opts)do
    map_action(controller_action)
  end

  @doc false
  def fetch_user(conn, %{user: user_fun}) when is_function(user_fun, 1) do
    user_fun.(conn)
  end

  def fetch_user(conn, %{}) do
    conn.assigns[:current_user]
  end

  @doc """
  Maps RESTful controller action to policy action.
  If non-RESTful controller action passed, returns controller action.

  RESTful controller actions are:
  * `:index`, `:new`, `:create`, `:show`, `:edit`, `:update`, `:delete`

  RESTful policy actions are:
  * `:index`, `:create`, `:show`, `:update`, `:delete`

  ## Params
  * `controller_action` - atom

  ## Examples

      # returns :index
      map_action(:index)

      # returns :create
      map_action(:new)

      # returns :best
      map_action(:best)
  """

  @restul_actions %{
    index: :index,
    new: :create,
    create: :create,
    show: :show,
    edit: :update,
    update: :update,
    delete: :delete
  }

  def map_action(contoller_action) do
    case action = @restul_actions[contoller_action] do
      nil ->
        contoller_action
      _ ->
        action
    end
  end
end
