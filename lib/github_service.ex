defmodule GithubService do
  @moduledoc """
  GithubService keeps the contexts that define your domain
  and business logic.
  """

  alias GithubService.Repos

  def fetch_repo_assync(user, repository) do
    with {:ok, %{issues: issues_data, contributors: contributors_data}} <-
           HttpClients.fetch_repo_assync(user, repository),
         {:ok, repository} <-
           Repos.parse_and_build_repository(user, repository, issues_data, contributors_data),
         {:ok, %{id: repository_id}} <- Repos.insert_repository(repository),
         {:ok, %{scheduled_at: scheduled_at}} <- Repos.schedule_repo_send(repository_id) do
      {:ok, %{repository_id: repository_id, scheduled_at: scheduled_at}}
    end
  end
end
