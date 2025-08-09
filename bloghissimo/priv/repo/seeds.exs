# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:

alias Bloghissimo.Accounts
alias Bloghissimo.Blog

# Create a test user
{:ok, user} = Accounts.create_user(%{
  name: "John",
  surname: "Doe",
  email: "john@example.com",
  password: "password123",
  phone: "+1234567890",
  address: "123 Main St",
  city: "San Francisco",
  country: "USA",
  cap: "94102"
})

# Create some test blog posts
{:ok, _blog1} = Blog.create_blog(%{
  title: "Welcome to Bloghissimo!",
  description_short: "An introduction to our new blogging platform.",
  description: """
  Welcome to Bloghissimo, your new personal blogging platform!

  This is a sample blog post to show you how everything works. You can write about anything you want - your thoughts, experiences, tutorials, or just daily life.

  The platform supports:
  - User authentication and profiles
  - Rich text content with line breaks
  - Image support for your posts
  - Clean, readable URLs with slugs

  Get started by creating your account and writing your first post!
  """,
  image: "https://imgs.search.brave.com/7-20dUPTK6k0mYkGBJXXdqK-yoSLOQuGyuP2uzM8s7g/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9hc3Nl/dHMudG9wdGFsLmlv/L2ltYWdlcz91cmw9/aHR0cHM6Ly9icy11/cGxvYWRzLnRvcHRh/bC5pby9ibGFja2Zp/c2gtdXBsb2Fkcy9j/b21wb25lbnRzL2Js/b2dfcG9zdF9wYWdl/LzQwODc2OTIvY292/ZXJfaW1hZ2UvcmVn/dWxhcl8xNzA4eDY4/My8wNzA5LU1lZXRf/UGhvZW5peF9BX1Jh/aWxzLWxpa2VfRnJh/bWV3b3JrX2Zvcl9N/b2Rlcm5fV2ViX0Fw/cHNfb25fRWxpeGly/X0Rhbl9OZXdzbGV0/dGVyLTg4YTk3ZDQ0/OWVmYzUyMDdmMzky/NWQ1YTc3ODM4MmRh/LnBuZw",
  user_id: user.id,
  user_fullname: user.fullname
})

{:ok, _blog2} = Blog.create_blog(%{
  title: "Getting Started with Phoenix",
  description_short: "A beginner's guide to the Phoenix web framework.",
  description: """
  Phoenix is an amazing web framework for building fast, reliable applications in Elixir.

  What makes Phoenix special:
  - Real-time features with LiveView
  - Fault-tolerant by design
  - High performance and scalability
  - Developer-friendly with great tooling

  If you're coming from other web frameworks, you'll find Phoenix refreshingly productive while offering the power and reliability of the Erlang ecosystem.

  This blog was built with Phoenix and showcases some of its capabilities!
  """,
  image: "https://imgs.search.brave.com/GkdL122Jti9ShZdrqyEbZFUKYb9c_ajvinuZiU5Bnd0/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9waG9l/bml4ZnJhbWV3b3Jr/Lm9yZy9pbWFnZXMv/YmxvZy8xLTgucG5n",
  user_id: user.id,
  user_fullname: user.fullname
})

IO.puts("Seeded database with test user and blog posts!")
IO.puts("Test user: john@example.com / password123")
