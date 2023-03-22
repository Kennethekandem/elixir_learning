defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.{User, Repo}

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}

    changeset = User.changeset(%User{}, user_params)

    with {:ok, user} <- insert_or_update_user(changeset) do

    end
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(user_id: user.id)
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in!")
        |> redirect(to: Routes.topic_path(conn, :index))

    end
  end

  defp insert_or_update_user(changeset) do

    case Repo.get_by(User, :email, changeset.changes.email) do
      user ->
        {:ok, user}
      nil ->
        Repo.insert(changeset)
    end
  end

end
