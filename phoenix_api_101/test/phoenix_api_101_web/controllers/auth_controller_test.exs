defmodule PhoenixApi101Web.AuthControllerTest do
  use PhoenixApi101Web.ConnCase

  alias PhoenixApi101.Accounts

  @moduletag :auth

  @create_attrs %{password: "some password", username: "some username"}
  @input_attrs %{password: "some password", username: "some username"}
  @invalid_attrs %{password: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "auth" do
    setup [:create_user, :issue_token]

    test "request protected resource", %{conn: conn, user: user, token: token} do
      # request without access token returns unauthorized status
      conn = get(conn, "/v1/users/me")
      assert response(conn, :unauthorized)

      # request with access token returns success code
      conn = get(conn, "/v1/users/me", %{access_token: token})
      assert response(conn, :ok)
    end

    test "access token in request header", %{conn: conn, user: user, token: token} do
      # request with access token in request header returns success code
      conn =
        conn
        |> put_req_header("Authorization", "Bearer #{token}")
        |> get("/v1/users/me")

      assert response(conn, :ok)
      data = json_response(conn, :ok)["data"]
      assert data["attributes"]["username"] == user.username
    end

    test "user can't issue access token with invalid attrs", %{conn: conn, user: user} do
      # grant type is wrong
      params = %{
        grant_type: "client_credentials",
        username: user.username,
        password: user.password
      }

      conn = post(conn, "/v1/oauth2/token", params)
      assert response(conn, :unprocessable_entity)

      # request with invalid username and password
      params = %{
        grant_type: "password",
        username: @invalid_attrs.username,
        password: @invalid_attrs.password
      }

      conn = post(conn, "/v1/oauth2/token", params)
      assert response(conn, :unauthorized)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  @doc """
    Issue access token by password grant type
  """
  defp issue_token(%{conn: conn, user: user} = _args) do
    # request parameters
    params = %{
      grant_type: "password",
      username: user.username,
      password: user.password
    }

    # request access token
    conn = post(conn, "/v1/oauth2/token", params)
    token = json_response(conn, :created)["access_token"]

    {:ok, token: token}
  end
end
