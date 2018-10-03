defmodule PhoenixApi101.ElasticsearchStore do
  @behaviour Elasticsearch.Store

  import Ecto.Query

  alias PhoenixApi101.Repo

  def load(schema, offset, limit) do
    schema
    |> offset(^offset)
    |> limit(^limit)
    |> Repo.all()
  end
end
