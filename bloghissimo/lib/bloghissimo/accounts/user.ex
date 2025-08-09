defmodule Bloghissimo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :surname, :string
    field :fullname, :string
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :password_hash, :string, redact: true
    field :phone, :string
    field :address, :string
    field :city, :string
    field :country, :string
    field :cap, :string

    has_many :blogs, Bloghissimo.Blog.Blog

    timestamps(type: :utc_datetime)
  end

  @doc """
  A user changeset for registration.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:name, :surname, :email, :password, :phone, :address, :city, :country, :cap])
    |> validate_required([:name, :surname, :email, :password])
    |> validate_email()
    |> validate_password(opts)
    |> put_fullname()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Bloghissimo.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 72)
    |> maybe_hash_password(opts)
  end

  defp put_fullname(changeset) do
    name = get_field(changeset, :name)
    surname = get_field(changeset, :surname)

    case {name, surname} do
      {name, surname} when is_binary(name) and is_binary(surname) ->
        put_change(changeset, :fullname, "#{name} #{surname}")

      _ ->
        changeset
    end
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> validate_length(:password, min: 6, max: 72)
      |> put_change(:password_hash, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.
  """
  def email_changeset(user, attrs, _opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> validate_email(changeset)
      %{} = changeset -> changeset
    end
  end

  @doc """
  A user changeset for changing the password.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  A user changeset for updating user profile.
  """
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname, :email, :phone, :address, :city, :country, :cap])
    |> validate_required([:name, :surname, :email])
    |> validate_email()
    |> put_fullname()
  end

  @doc """
  Verifies the password.
  """
  def valid_password?(%Bloghissimo.Accounts.User{password_hash: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end
end