defmodule PhoenixApi101Web.PageController do
  use PhoenixApi101Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
