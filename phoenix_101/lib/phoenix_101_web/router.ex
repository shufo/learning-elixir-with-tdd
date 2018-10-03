defmodule Phoenix101Web.Router do
  use Phoenix101Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", Phoenix101Web do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)

    resources("/users", UserController)
    resources("/posts", PostController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", Phoenix101Web do
  #   pipe_through :api
  # end
end
