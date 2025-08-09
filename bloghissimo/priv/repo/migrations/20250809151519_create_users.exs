defmodule Bloghissimo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :surname, :string, null: false
      add :fullname, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :phone, :string
      add :address, :string
      add :city, :string
      add :country, :string
      add :cap, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end
