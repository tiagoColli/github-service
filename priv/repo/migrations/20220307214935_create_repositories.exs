defmodule GithubService.Repo.Migrations.CreateRepositories do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :user, :string, null: false
      add :repository, :string, null: false
      add :issues, :map
      add :contributors, :map

      timestamps()
    end
  end
end
