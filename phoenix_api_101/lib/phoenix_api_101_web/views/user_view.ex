defmodule PhoenixApi101Web.UserView do
  use PhoenixApi101Web, :view
  use JaSerializer.PhoenixView

  attributes([:password, :username, :inserted_at, :updated_at])
end
