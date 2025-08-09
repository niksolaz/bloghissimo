defmodule BloghissimoWeb.AuthController do
  use BloghissimoWeb, :controller

  alias Bloghissimo.Accounts

  def login(conn, _params) do
    render(conn, :login)
  end

  def create_session(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      %Bloghissimo.Accounts.User{} = user ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: ~p"/")

      _ ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> render(:login)
    end
  end

  def delete_session(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: ~p"/")
  end

  def register(conn, _params) do
    changeset = Accounts.change_user_registration(%Bloghissimo.Accounts.User{})
    render(conn, :register, changeset: changeset)
  end

  def create_user(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Account created successfully!")
        |> redirect(to: ~p"/")

      {:error, changeset} ->
        render(conn, :register, changeset: changeset)
    end
  end
end