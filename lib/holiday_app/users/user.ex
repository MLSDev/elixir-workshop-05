defmodule HolidayApp.Users.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string

    field :uid, :string
    field :provider, :string, default: "identity"

    field :name, :string
    field :photo_url, :string, size: 2048
    field :hosted_domain, :string

    field :role, :string, default: "employee"

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @required_identity_fields [:provider, :email, :password, :password_confirmation]
  @required_fields          [:provider, :email, :uid]

  @changeable_fields [
    :uid,
    :provider,
    :password,
    :password_confirmation,
    :name,
    :photo_url,
    :hosted_domain
  ]

  @doc false
  def create_changeset(struct, attrs)

  def create_changeset(struct, %{provider: "identity"} = attrs) do
    struct
    |> cast(attrs, @required_identity_fields)
    |> validate_required(@required_identity_fields)
    |> validate_email(:email)
    |> verify_password()
  end

  def create_changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ [:name, :photo_url, :hosted_domain])
    |> validate_required(@required_fields)
    |> validate_provider()
    |> unique_constraint(:uid)
    |> validate_email(:email)
    |> validate_url(:photo_url)
    |> validate_url(:hosted_domain)
  end

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @changeable_fields)
    |> unique_constraint(:uid)
    |> validate_provider()
    |> verify_password()
    |> validate_url(:hosted_domain)
    |> validate_url(:photo_url)
    |> validate_length(:name, min: 2)
  end

  defp validate_provider(changeset) do
    validate_inclusion(changeset, :provider, ["identity", "google", "facebook"])
  end

  defp validate_email(changeset, field) do
    changeset
    |> validate_format(field, ~r/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
    |> unique_constraint(field)
  end

  defp validate_url(changeset, field) do
    regex = ~r/(?:https?:\/\/)?(?:[\w]+\.)([a-zA-Z\.]{2,6})([\/\w\.-]*)*\/?/i
    validate_format(changeset, field, regex)
  end

  defp verify_password(changeset) do
    changeset
    |> validate_length(:password, min: 8, max: 64)
    |> validate_confirmation(:password, message: "does not match password")
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end
  defp put_pass_hash(changeset), do: changeset
end
