defmodule BloghissimoWeb.Plugs.Auth do
  @moduledoc """
  Authentication plug to load current user from session.
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    
    case user_id do
      nil ->
        assign(conn, :current_user, nil)
      user_id ->
        try do
          user = Bloghissimo.Accounts.get_user!(user_id)
          assign(conn, :current_user, user)
        rescue
          _ -> assign(conn, :current_user, nil)
        end
    end
  end
end