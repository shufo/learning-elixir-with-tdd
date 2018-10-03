defmodule Phoenix101Web.AuthControllerTest do
  use Phoenix101Web.ConnCase

  alias Phoenix101.Accounts

  @create_attrs %{password: "some password", username: "some username"}
  @input_attrs %{password: "some password", username: "some username"}
  @invalid_attrs %{password: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "login" do
    setup [:create_user]

    test "get login page", %{conn: conn} do
      # get login page
      conn = get(conn, "/auth/login")

      # assert the login page includes `Login` string
      assert html_response(conn, 200) =~ "Login"
    end

    test "redirects when login succeed", %{conn: conn, user: user} do
      # try login with created username and password
      conn =
        post(
          conn,
          "/auth/login",
          username: user.username,
          password: user.password
        )

      # assert redirected to top page when login succeed
      assert redirected_to(conn) == page_path(conn, :index)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
