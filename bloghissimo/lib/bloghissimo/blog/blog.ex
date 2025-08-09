defmodule Bloghissimo.Blog.Blog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blogs" do
    field :image, :string
    field :title, :string
    field :slug, :string
    field :user_fullname, :string
    field :description, :string
    field :description_short, :string

    belongs_to :user, Bloghissimo.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(blog, attrs) do
    blog
    |> cast(attrs, [:image, :title, :description, :description_short, :user_id, :user_fullname])
    |> validate_required([:title, :description, :description_short, :user_id, :user_fullname])
    |> validate_length(:title, min: 3, max: 200)
    |> validate_length(:description_short, max: 300)
    |> generate_slug()
    |> unique_constraint(:slug)
  end

  defp generate_slug(changeset) do
    case get_change(changeset, :title) do
      nil -> changeset
      title ->
        slug =
          title
          |> String.downcase()
          |> String.replace(~r/[^\w\s-]/, "")
          |> String.replace(~r/\s+/, "-")
          |> String.trim("-")

        put_change(changeset, :slug, slug)
    end
  end
end