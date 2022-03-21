defmodule HttpClients.Github do
  @moduledoc """
  Contains logic to make http calls to github's repositories public api.
  """

  use Tesla

  @behaviour HttpClients.GithubBehaviour

  plug Tesla.Middleware.BaseUrl,
       Application.get_env(:github_service, :github_base_api) <> "/repos"

  plug Tesla.Middleware.Headers, [{"User-Agent", "GithubService"}]

  plug Tesla.Middleware.JSON

  @issues_path "/issues"
  @contributors_path "/contributors"

  @doc """
  Makes a call to the github api fetching issues from a given repository.

  ## Examples

      iex> list_repo_issues("user", "repo")
      {:ok, result}

      iex> list_repo_issues("user", "repox")
      {:error, "Some error"}
  """
  def list_repo_issues(user_name, repo_name) do
    user_name
    |> build_url(repo_name, @issues_path)
    |> get()
  end

  @doc """
  Makes a call to the github api fetching contributors from a given repository.

  ## Examples

      iex> list_repo_contributors("user", "repo")
      {:ok, result}

      iex> list_repo_contributors("user", "repox")
      {:error, result}
  """
  def list_repo_contributors(user_name, repo_name) do
    user_name
    |> build_url(repo_name, @contributors_path)
    |> get()
  end

  defp build_url(user_name, repo_name, filter) do
    "/" <> user_name <> "/" <> repo_name <> filter
  end
end
