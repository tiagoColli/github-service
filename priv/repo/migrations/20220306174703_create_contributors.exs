defmodule GithubService.Repo.Migrations.CreateContributors do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:contributors) do
      add :name, :string
      add :user, :string
      add :qtd_commits, :integer
      add :github_id, :integer
      add :repository_id, references(:repositories, on_delete: :nothing)

      timestamps()
    end

    create index(:contributors, [:repository_id])
    unique_index(:contributors, [:repository_id, :github_id])
  end
end
