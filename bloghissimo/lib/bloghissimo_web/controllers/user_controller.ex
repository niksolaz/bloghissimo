defmodule BloghissimoWeb.UserController do
  use BloghissimoWeb, :controller

  alias Bloghissimo.Accounts

  def profile(conn, _params) do
    case get_current_user(conn) do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in to view your profile.")
        |> redirect(to: ~p"/login")

      user ->
        changeset = Accounts.change_user(user)
        render(conn, :profile, user: user, changeset: changeset)
    end
  end

  def update_profile(conn, %{"user" => user_params}) do
    case get_current_user(conn) do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in to update your profile.")
        |> redirect(to: ~p"/login")

      user ->
        case Accounts.update_user(user, user_params) do
          {:ok, _updated_user} ->
            conn
            |> put_flash(:info, "Profile updated successfully.")
            |> redirect(to: ~p"/profile")

          {:error, changeset} ->
            render(conn, :profile, user: user, changeset: changeset)
        end
    end
  end

  defp get_current_user(conn) do
    case get_session(conn, :user_id) do
      nil -> nil
      user_id -> Accounts.get_user!(user_id)
    end
  end
end