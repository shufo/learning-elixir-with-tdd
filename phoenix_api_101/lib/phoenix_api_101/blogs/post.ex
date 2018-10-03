defmodule PhoenixApi101.Blogs.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [usec: false]

  schema "posts" do
    field(:body, :string)
    field(:title, :string)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end

  defimpl Elasticsearch.Document, for: __MODULE__ do
    def id(post), do: post.id

    def encode(post) do
      %{
        title: post.title,
        body: post.body
      }
    end
  end
end
