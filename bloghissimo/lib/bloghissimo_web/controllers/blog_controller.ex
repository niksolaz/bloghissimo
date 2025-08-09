defmodule BloghissimoWeb.BlogController do
  use BloghissimoWeb, :controller

  alias Bloghissimo.Blog
  alias Bloghissimo.Blog.Blog, as: BlogPost

  def index(conn, _params) do
    blogs = Blog.list_blogs_with_user()
    render(conn, :index, blogs: blogs)
  end

  def show(conn, %{"slug" => slug}) do
    blog = Blog.get_blog_by_slug!(slug)
    render(conn, :show, blog: blog)
  end

  def new(conn, _params) do
    case get_current_user(conn) do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in to create a blog post.")
        |> redirect(to: ~p"/login")

      user ->
        changeset = Blog.change_blog(%BlogPost{})
        render(conn, :new, changeset: changeset, user: user)
    end
  end

  def create(conn, %{"blog" => blog_params}) do
    case get_current_user(conn) do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in to create a blog post.")
        |> redirect(to: ~p"/login")

      user ->
        blog_params_with_user = 
          blog_params
          |> Map.put("user_id", user.id)
          |> Map.put("user_fullname", user.fullname)

        case Blog.create_blog(blog_params_with_user) do
          {:ok, blog} ->
            conn
            |> put_flash(:info, "Blog post created successfully.")
            |> redirect(to: ~p"/blogs/#{blog.slug}")

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, :new, changeset: changeset, user: user)
        end
    end
  end

  def edit(conn, %{"slug" => slug}) do
    blog = Blog.get_blog_by_slug!(slug)
    user = get_current_user(conn)

    cond do
      is_nil(user) ->
        conn
        |> put_flash(:error, "You must be logged in to edit a blog post.")
        |> redirect(to: ~p"/login")

      blog.user_id != user.id ->
        conn
        |> put_flash(:error, "You can only edit your own blog posts.")
        |> redirect(to: ~p"/blogs")

      true ->
        changeset = Blog.change_blog(blog)
        render(conn, :edit, blog: blog, changeset: changeset)
    end
  end

  def update(conn, %{"slug" => slug, "blog" => blog_params}) do
    blog = Blog.get_blog_by_slug!(slug)
    user = get_current_user(conn)

    cond do
      is_nil(user) ->
        conn
        |> put_flash(:error, "You must be logged in to edit a blog post.")
        |> redirect(to: ~p"/login")

      blog.user_id != user.id ->
        conn
        |> put_flash(:error, "You can only edit your own blog posts.")
        |> redirect(to: ~p"/blogs")

      true ->
        case Blog.update_blog(blog, blog_params) do
          {:ok, blog} ->
            conn
            |> put_flash(:info, "Blog post updated successfully.")
            |> redirect(to: ~p"/blogs/#{blog.slug}")

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, :edit, blog: blog, changeset: changeset)
        end
    end
  end

  def delete(conn, %{"slug" => slug}) do
    blog = Blog.get_blog_by_slug!(slug)
    user = get_current_user(conn)

    cond do
      is_nil(user) ->
        conn
        |> put_flash(:error, "You must be logged in to delete a blog post.")
        |> redirect(to: ~p"/login")

      blog.user_id != user.id ->
        conn
        |> put_flash(:error, "You can only delete your own blog posts.")
        |> redirect(to: ~p"/blogs")

      true ->
        {:ok, _blog} = Blog.delete_blog(blog)

        conn
        |> put_flash(:info, "Blog post deleted successfully.")
        |> redirect(to: ~p"/blogs")
    end
  end

  defp get_current_user(conn) do
    case get_session(conn, :user_id) do
      nil -> nil
      user_id -> Bloghissimo.Accounts.get_user!(user_id)
    end
  end
end