defmodule GithubService.Repo.Migrations.CreateRepositories do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :user, :string
      add :repository, :string

      timestamps()
    end
  end
end
