defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.{User, Repo}

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}

    changeset = User.changeset(%User{}, user_params)
    signin(conn, changeset)

  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, %User{id: user_id} = _user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> Plug.Conn.put_session(:user_id, user_id)
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in!")
        |> redirect(to: Routes.topic_path(conn, :index))

    end
  end

  def signout(conn, _param) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  defp insert_or_update_user(changeset) do

    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

end
