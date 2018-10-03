defmodule PhoenixApi101Web.Router do
  use PhoenixApi101Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json", "json-api"])
  end

  scope "/", PhoenixApi101Web do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  scope "/v1", PhoenixApi101Web do
    pipe_through(:api)
    resources("/users", UserController, except: [:new, :edit])
    resources("/posts", PostController, except: [:new, :edit])
  end
end
