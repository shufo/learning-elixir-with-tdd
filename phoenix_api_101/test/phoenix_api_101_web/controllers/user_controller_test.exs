defmodule PhoenixApi101Web.UserControllerTest do
  use PhoenixApi101Web.ConnCase

  alias PhoenixApi101.Accounts
  alias PhoenixApi101.Accounts.User

  @create_attrs %{password: "some password", username: "some username"}
  @update_attrs %{password: "some updated password", username: "some updated username"}
  @invalid_attrs %{password: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  defp relationships do
    %{}
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, user_path(conn, :index))
    assert json_response(conn, 200)["data"] == []
  end

  test "lists entries on index up to 10 users", %{conn: conn} do
    # create 20 users
    for _ <- 1..20, do: fixture(:user)

    # get users
    conn = get(conn, user_path(conn, :index))

    # returns up to 10 users per page
    assert json_response(conn, 200)["data"] |> length == 10
  end

  test "paging index entries", %{conn: conn} do
    # create 15 users
    for _ <- 1..15, do: fixture(:user)

    # get users
    conn = get(conn, user_path(conn, :index))

    # returns up to 10 users per page
    assert json_response(conn, 200)["data"] |> length == 10

    # get users on page 2
    conn = get(conn, user_path(conn, :index), %{page: 2})

    # returns 5 users on page 2
    assert json_response(conn, 200)["data"] |> length == 5

    # get users on page 3
    conn = get(conn, user_path(conn, :index), %{page: 3})

    # returns 0 users on page 3
    assert json_response(conn, 200)["data"] == []
  end

  test "creates user and renders user when data is valid", %{conn: conn} do
    conn =
      post(conn, user_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "user",
          "attributes" => @create_attrs,
          "relationships" => relationships
        }
      })

    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get(conn, user_path(conn, :show, id))
    data = json_response(conn, 200)["data"]
    assert data["id"] == id
    assert data["type"] == "user"
    assert data["attributes"]["password"] == @create_attrs.password
    assert data["attributes"]["username"] == @create_attrs.username
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn =
      post(conn, user_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "user",
          "attributes" => @invalid_attrs,
          "relationships" => relationships
        }
      })

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen user and renders user when data is valid", %{conn: conn} do
    %User{id: id} = user = fixture(:user)

    conn =
      put(conn, user_path(conn, :update, user), %{
        "meta" => %{},
        "data" => %{
          "type" => "user",
          "id" => "#{user.id}",
          "attributes" => @update_attrs,
          "relationships" => relationships
        }
      })

    conn = get(conn, user_path(conn, :show, id))
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{id}"
    assert data["type"] == "user"
    assert data["attributes"]["password"] == @update_attrs.password
    assert data["attributes"]["username"] == @update_attrs.username
  end

  test "does not update chosen user and renders errors when data is invalid", %{conn: conn} do
    user = fixture(:user)

    conn =
      put(conn, user_path(conn, :update, user), %{
        "meta" => %{},
        "data" => %{
          "type" => "user",
          "id" => "#{user.id}",
          "attributes" => @invalid_attrs,
          "relationships" => relationships
        }
      })

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not update user when password is too short (less than 8 characters)", %{conn: conn} do
    user = fixture(:user)

    invalid_update_attrs = %{password: "short", username: "some username"}

    conn =
      put(conn, user_path(conn, :update, user), %{
        "meta" => %{},
        "data" => %{
          "type" => "user",
          "id" => "#{user.id}",
          "attributes" => invalid_update_attrs,
          "relationships" => relationships
        }
      })

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not update user when username contains invalid character (%)", %{conn: conn} do
    user = fixture(:user)

    invalid_update_attrs = %{password: "some password", username: "invalid % username"}

    conn =
      put(conn, user_path(conn, :update, user), %{
        "meta" => %{},
        "data" => %{
          "type" => "user",
          "id" => "#{user.id}",
          "attributes" => invalid_update_attrs,
          "relationships" => relationships
        }
      })

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen user", %{conn: conn} do
    user = fixture(:user)
    conn = delete(conn, user_path(conn, :delete, user))
    assert response(conn, 204)

    assert_error_sent(404, fn ->
      get(conn, user_path(conn, :show, user))
    end)
  end

  test "create user through the create api", %{conn: conn} = _context do
    # user fixture
    user = fixture(:user)

    # create request
    conn =
      post(conn, user_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "user",
          "attributes" => @create_attrs,
          "relationships" => relationships
        }
      })

    # get response
    assert %{"id" => id} = json_response(conn, :created)["data"]

    # assert the attributes of created user
    conn = get(conn, user_path(conn, :show, id))
    data = json_response(conn, 200)["data"]
    assert data["id"] == id
    assert data["type"] == "user"
    assert data["attributes"]["password"] == @create_attrs.password
    assert data["attributes"]["username"] == @create_attrs.username
  end

  test "does not create same username twice", %{conn: conn} = _context do
    # create request
    conn =
      post(conn, user_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "user",
          "attributes" => @create_attrs,
          "relationships" => relationships
        }
      })

    # create request with same username
    conn =
      post(conn, user_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "user",
          "attributes" => @create_attrs,
          "relationships" => relationships
        }
      })

    # assert the response is error
    assert json_response(conn, :conflict)
  end

  test "does not create when password is too short (less than 8 characters)", %{conn: conn} do
    # create request
    invalid_create_attrs = %{password: "short", username: "some username"}

    conn =
      post(conn, user_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "user",
          "attributes" => invalid_create_attrs,
          "relationships" => relationships
        }
      })

    # assert the response is unprocessable
    assert json_response(conn, :unprocessable_entity)
  end

  test "does not create when username contains invalid character (%)", %{conn: conn} = _context do
    # create request
    invalid_create_attrs = %{password: "some password", username: "invalid % username"}

    conn =
      post(conn, user_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "user",
          "attributes" => invalid_create_attrs,
          "relationships" => relationships
        }
      })

    # assert the response is unprocessable
    assert json_response(conn, :unprocessable_entity)
  end
end
