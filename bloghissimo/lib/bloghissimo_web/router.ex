defmodule BloghissimoWeb.Router do
  use BloghissimoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BloghissimoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BloghissimoWeb.Plugs.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BloghissimoWeb do
    pipe_through :browser

    get "/", PageController, :home
    
    # Authentication routes
    get "/login", AuthController, :login
    post "/login", AuthController, :create_session
    delete "/logout", AuthController, :delete_session
    get "/register", AuthController, :register
    post "/register", AuthController, :create_user
    
    # User profile routes
    get "/profile", UserController, :profile
    put "/profile", UserController, :update_profile
    
    # Blog routes
    get "/blogs", BlogController, :index
    get "/blogs/new", BlogController, :new
    post "/blogs", BlogController, :create
    get "/blogs/:slug", BlogController, :show
    get "/blogs/:slug/edit", BlogController, :edit
    put "/blogs/:slug", BlogController, :update
    delete "/blogs/:slug", BlogController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", BloghissimoWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bloghissimo, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BloghissimoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
