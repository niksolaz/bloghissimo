defmodule Bloghissimo.Repo do
  use Ecto.Repo,
    otp_app: :bloghissimo,
    adapter: Ecto.Adapters.SQLite3
end
