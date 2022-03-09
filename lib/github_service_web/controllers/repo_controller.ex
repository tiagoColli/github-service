defmodule GithubServiceWeb.RepoController do
  @doc """
  Contains logic to handle http calls related to github repositories.
  """

  use GithubServiceWeb, :controller

  alias GithubService.Repos

  action_fallback GithubServiceWeb.FallbackController

  def fetch_repo_assync(conn, %{"user" => user, "repository" => repository}) do
    with {:ok, %{issues: issues_data, contributors: contributors_data}} <-
           Repos.fetch_repo_assync(user, repository),
         {:ok, repository} <-
           Repos.parse_and_build_repository(user, repository, issues_data, contributors_data),
         {:ok, %{id: repository_id}} <- Repos.insert_repository(repository),
         {:ok, %{scheduled_at: scheduled_at}} <- Repos.schedule_repo_send(repository_id) do
      conn
      |> put_status(:ok)
      |> json(%{
        message: "Webhook scheduled with success",
        repository_id: repository_id,
        scheduled_at: scheduled_at
      })
    end
  end
end
