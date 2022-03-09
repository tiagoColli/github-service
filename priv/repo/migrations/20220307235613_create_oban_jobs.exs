defmodule GithubService.Repo.Migrations.CreateObanJobs do
  @moduledoc false

  use Ecto.Migration

  defdelegate up, to: Oban.Migrations
  defdelegate down, to: Oban.Migrations
end
