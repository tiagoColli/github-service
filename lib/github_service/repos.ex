defmodule GithubService.Repos do
  @moduledoc """
  The Repos context.
  """

  alias GithubService.Repo
  alias GithubService.Repos.Repository
  alias GithubService.Repos.Workers.SendRepoWorker
  alias HttpClients.Parsers.Github

  @one_day 60 * 60 * 24

  def insert_repository(repository) do
    %Repository{}
    |> Repository.changeset(repository)
    |> Repo.insert()
  end

  def get_repository(id), do: Repo.get(Repository, id)

  def parse_and_build_repository(user, repository, issues, contributors) do
    with {:ok, parsed_issues} <- Github.parse_issues(issues),
         {:ok, parsed_contributors} <- Github.parse_contributors(contributors) do
      {:ok, build_repository_map(user, repository, parsed_issues, parsed_contributors)}
    end
  end

  def schedule_repo_send(repository_id) do
    case SendRepoWorker.new(%{"repository_id" => repository_id}, schedule_in: @one_day) do
      %{valid?: true} = changeset -> Oban.insert(changeset)
      changeset -> {:error, changeset}
    end
  end

  defp build_repository_map(user, repository, issues, contributors) do
    %{
      user: user,
      repository: repository,
      issues: issues,
      contributors: contributors
    }
  end
end
