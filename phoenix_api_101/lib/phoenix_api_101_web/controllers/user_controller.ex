defmodule PhoenixApi101Web.UserController do
  use PhoenixApi101Web, :controller

  alias PhoenixApi101.Accounts
  alias PhoenixApi101.Accounts.User
  alias JaSerializer.Params

  action_fallback(PhoenixApi101Web.FallbackController)

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json-api", data: users)
  end

  def create(conn, %{"data" => data = %{"type" => "user", "attributes" => user_params}}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json-api", data: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json-api", data: user)
  end

  def update(conn, %{
        "id" => id,
        "data" => data = %{"type" => "user", "attributes" => user_params}
      }) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json-api", data: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
