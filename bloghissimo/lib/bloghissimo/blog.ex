defmodule Bloghissimo.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Bloghissimo.Repo
  alias Bloghissimo.Blog.Blog

  @doc """
  Returns the list of blogs.
  """
  def list_blogs do
    Repo.all(Blog)
  end

  @doc """
  Returns the list of blogs with preloaded user.
  """
  def list_blogs_with_user do
    Blog
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Gets a single blog by ID.
  """
  def get_blog!(id), do: Repo.get!(Blog, id)

  @doc """
  Gets a single blog by slug.
  """
  def get_blog_by_slug!(slug) do
    Blog
    |> preload(:user)
    |> Repo.get_by!(slug: slug)
  end

  @doc """
  Gets blogs for a specific user.
  """
  def list_user_blogs(user_id) do
    Blog
    |> where([b], b.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Creates a blog.
  """
  def create_blog(attrs \\ %{}) do
    %Blog{}
    |> Blog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a blog.
  """
  def update_blog(%Blog{} = blog, attrs) do
    blog
    |> Blog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a blog.
  """
  def delete_blog(%Blog{} = blog) do
    Repo.delete(blog)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking blog changes.
  """
  def change_blog(%Blog{} = blog, attrs \\ %{}) do
    Blog.changeset(blog, attrs)
  end
end