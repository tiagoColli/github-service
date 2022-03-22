defmodule GithubService.Repos.Workers.SendRepoWorker do
  @moduledoc """
  Contains the logic that sends information related to repositories.
  """

  use Oban.Worker

  alias GithubService.Repos

  @doc """
  Contains the worker logic that fetches information from a given repository from the database
  and sends it through a webhook to the client.
  """
  def perform(%Oban.Job{args: %{"repository_id" => repository_id}}) do
    with {:ok, json_data} <- get_and_encode_repository(repository_id) do
      HttpClients.post_to_webhook_site(json_data)
    end
  end

  defp get_and_encode_repository(repository_id) do
    repository_id
    |> Repos.get_repository()
    |> Jason.encode()
  end
end
