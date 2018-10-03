defmodule PhoenixApi101Web.PostView do
  use PhoenixApi101Web, :view
  use JaSerializer.PhoenixView

  attributes([:body, :title, :inserted_at, :updated_at])
end
