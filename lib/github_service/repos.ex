defmodule GithubService.Repos do
  @moduledoc """
  The Repos context.
  """

  alias GithubService.Repo
  alias GithubService.Repos.FetchAssync
  alias GithubService.Repos.HttpClients.GithubParser
  alias GithubService.Repos.Repository
  alias GithubService.Repos.Workers.SendRepoWorker
  alias Utils.Handlers.Tesla

  @http_client Application.compile_env(
                 :github_service,
                 :github_http_client,
                 GithubService.Repos.HttpClients.Github
               )

  @one_day 60 * 60 * 24

  def insert_repository(repository) do
    %Repository{}
    |> Repository.changeset(repository)
    |> Repo.insert()
  end

  def get_repository(id), do: Repo.get(Repository, id)

  def parse_and_build_repository(user, repository, issues, contributors) do
    with {:ok, parsed_issues} <- GithubParser.parse_issues(issues),
         {:ok, parsed_contributors} <- GithubParser.parse_contributors(contributors) do
      {:ok, build_repository_map(user, repository, parsed_issues, parsed_contributors)}
    end
  end

  def get_issues_from_github(user_name, repo_name) do
    user_name
    |> @http_client.list_repo_issues(repo_name)
    |> Tesla.handle()
  end

  def get_contributors_from_github(user_name, repo_name) do
    user_name
    |> @http_client.list_repo_contributors(repo_name)
    |> Tesla.handle()
  end

  def schedule_repo_send(repository_id) do
    case SendRepoWorker.new(%{"repository_id" => repository_id}, schedule_in: 5) do
      %{valid?: true} = changeset -> Oban.insert(changeset)
      changeset -> {:error, changeset}
    end
  end

  defdelegate fetch_repo_assync(user_name, repo_name),
    to: FetchAssync,
    as: :issues_and_contributors

  defp build_repository_map(user, repository, issues, contributors) do
    %{
      user: user,
      repository: repository,
      issues: issues,
      contributors: contributors
    }
  end
end
