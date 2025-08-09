defmodule Bloghissimo.Repo.Migrations.CreateBlogs do
  use Ecto.Migration

  def change do
    create table(:blogs) do
      add :image, :string
      add :title, :string, null: false
      add :slug, :string, null: false
      add :user_fullname, :string, null: false
      add :description, :text, null: false
      add :description_short, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:blogs, [:slug])
    create index(:blogs, [:user_id])
  end
end
