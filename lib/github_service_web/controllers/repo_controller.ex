defmodule GithubServiceWeb.RepoController do
  @doc """
  Contains logic to handle http calls related to github repositories.
  """

  use GithubServiceWeb, :controller

  action_fallback GithubServiceWeb.FallbackController

  def fetch_repo_assync(conn, %{"user" => user, "repository" => repository}) do
    with {:ok, %{repository_id: repository_id, scheduled_at: scheduled_at}} <-
           GithubService.fetch_repo_assync(user, repository) do
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
