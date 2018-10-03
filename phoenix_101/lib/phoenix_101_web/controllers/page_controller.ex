defmodule Phoenix101Web.PageController do
  use Phoenix101Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
