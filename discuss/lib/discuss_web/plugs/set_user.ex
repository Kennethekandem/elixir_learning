defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  def init(default), do: default

  def call(conn, _default) do
    user_id =
    conn
    |> get_session(:user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        conn
        |> assign(:user, user)
      true ->
        conn
        |> assign(:user, nil)
    end
  end
end
