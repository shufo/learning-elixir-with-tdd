defmodule PhoenixApi101Web.PostControllerTest do
  use PhoenixApi101Web.ConnCase

  alias PhoenixApi101.Blogs
  alias PhoenixApi101.Blogs.Post
  alias PhoenixApi101.ElasticsearchCluster

  @moduletag :post

  @create_attrs %{body: "some body", title: "some title"}
  @update_attrs %{body: "some updated body", title: "some updated title"}
  @invalid_attrs %{body: nil, title: nil}

  def fixture(:post) do
    {:ok, post} = Blogs.create_post(@create_attrs)
    post
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
    conn = get(conn, post_path(conn, :index))
    assert json_response(conn, 200)["data"] == []
  end

  test "lists entries on index up to 10 posts", %{conn: conn} do
    # create 20 posts
    for _ <- 1..20, do: fixture(:post)

    # get posts
    conn = get(conn, post_path(conn, :index))

    # returns up to 10 posts per page
    assert json_response(conn, 200)["data"] |> length == 10
  end

  test "paging entries", %{conn: conn} do
    # create 15 posts
    for _ <- 1..15, do: fixture(:post)

    # get posts
    conn = get(conn, post_path(conn, :index))

    # returns up to 10 posts per page
    assert json_response(conn, 200)["data"] |> length == 10

    # get posts on page 2
    conn = get(conn, post_path(conn, :index), %{page: 2})

    # returns 5 posts on page 2
    assert json_response(conn, 200)["data"] |> length == 5

    # get posts on page 3
    conn = get(conn, post_path(conn, :index), %{page: 3})

    # returns 0 posts on page 3
    assert json_response(conn, 200)["data"] == []
  end

  test "creates post and renders post when data is valid", %{conn: conn} do
    conn =
      post(conn, post_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "post",
          "attributes" => @create_attrs,
          "relationships" => relationships
        }
      })

    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get(conn, post_path(conn, :show, id))
    data = json_response(conn, 200)["data"]
    assert data["id"] == id
    assert data["type"] == "post"
    assert data["attributes"]["body"] == @create_attrs.body
    assert data["attributes"]["title"] == @create_attrs.title
  end

  test "does not create post and renders errors when data is invalid", %{conn: conn} do
    conn =
      post(conn, post_path(conn, :create), %{
        "meta" => %{},
        "data" => %{
          "type" => "post",
          "attributes" => @invalid_attrs,
          "relationships" => relationships
        }
      })

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen post and renders post when data is valid", %{conn: conn} do
    %Post{id: id} = post = fixture(:post)

    conn =
      put(conn, post_path(conn, :update, post), %{
        "meta" => %{},
        "data" => %{
          "type" => "post",
          "id" => "#{post.id}",
          "attributes" => @update_attrs,
          "relationships" => relationships
        }
      })

    conn = get(conn, post_path(conn, :show, id))
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{id}"
    assert data["type"] == "post"
    assert data["attributes"]["body"] == @update_attrs.body
    assert data["attributes"]["title"] == @update_attrs.title
  end

  test "does not update chosen post and renders errors when data is invalid", %{conn: conn} do
    post = fixture(:post)

    conn =
      put(conn, post_path(conn, :update, post), %{
        "meta" => %{},
        "data" => %{
          "type" => "post",
          "id" => "#{post.id}",
          "attributes" => @invalid_attrs,
          "relationships" => relationships
        }
      })

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen post", %{conn: conn} do
    post = fixture(:post)
    conn = delete(conn, post_path(conn, :delete, post))
    assert response(conn, 204)

    assert_error_sent(404, fn ->
      get(conn, post_path(conn, :show, post))
    end)
  end

  describe "elasticsearch" do
    setup [:delete_index, :create_index]

    test "search index" do
      result =
        Elasticsearch.post!(ElasticsearchCluster, "/posts/_doc/_search", %{
          "query" => %{"term" => %{title: "some"}}
        })

      assert result["hits"]["hits"] |> length == 10
    end

    test "create index by parameters" do
      Blogs.create_search_index(%{title: "foo", body: "bar"})

      Elasticsearch.Index.refresh(ElasticsearchCluster, "posts")

      result =
        Elasticsearch.post!(ElasticsearchCluster, "/posts/_doc/_search", %{
          "query" => %{"term" => %{title: "foo"}}
        })

      assert result["hits"]["hits"] |> length == 1
    end
  end

  defp delete_index(_) do
    Elasticsearch.delete(ElasticsearchCluster, "posts")
    :ok
  end

  defp create_index(_) do
    posts = for _ <- 1..10, do: fixture(:post)

    posts
    |> Enum.each(&Blogs.create_search_index(&1))

    Elasticsearch.Index.refresh(ElasticsearchCluster, "posts")

    {:ok, posts: posts}
  end
end
