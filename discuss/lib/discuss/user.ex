defmodule Discuss.User do
  use Ecto.Schema
  import Ecto.Changeset

  # @derive {Jason.Encoder, only: [:email.]}
  schema "users" do
    field(:email, :string)
    field(:provider, :string)
    field(:token, :string)

    timestamps()
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end
end
