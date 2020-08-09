defmodule PreviewWeb.Router do
  use PreviewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PreviewWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PreviewWeb do
    pipe_through :browser

    live "/", SearchLive, :index
    live "/preview/:package/:version", PreviewLive, :index
    # live "/searches", SearchLive.Index, :index
    # live "/searches/new", SearchLive.Index, :new
    # live "/searches/:id/edit", SearchLive.Index, :edit

    # live "/searches/:id", SearchLive.Show, :show
    # live "/searches/:id/show/edit", SearchLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", PreviewWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: PreviewWeb.Telemetry
    end
  end
end