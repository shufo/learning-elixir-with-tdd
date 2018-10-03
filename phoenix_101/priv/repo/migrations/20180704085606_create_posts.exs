defmodule Phoenix101.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :user_id, :integer
      add :title, :string
      add :body, :text

      timestamps()
    end

  end
end
