defmodule Phoenix101.Blogs.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [usec: false]

  schema "posts" do
    field(:body, :string)
    field(:title, :string)
    field(:user_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:user_id, :title, :body])
    |> validate_required([:user_id, :title, :body])
  end
end
