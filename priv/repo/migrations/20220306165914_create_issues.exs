defmodule GithubService.Repo.Migrations.CreateIssues do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:issues) do
      add :title, :string
      add :author, :string
      add :labels, {:array, :string}
      add :github_id, :integer
      add :repository_id, references(:repositories, on_delete: :nothing)

      timestamps()
    end

    create index(:issues, [:repository_id])
    unique_index(:issues, [:repository_id, :github_id])
  end
end
