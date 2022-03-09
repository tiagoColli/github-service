defmodule GithubService.Repos.FetchAssync do
  @moduledoc """
  Contains logic to fetch data assync from github.
  """

  alias GithubService.Repos

  @doc """
  Query github api asynchronously to fetch issue and contributor data from a given
  repository identified by name and owner.

  ## Examples

      iex> issues_and_contributors("user", "repo")
      {:ok, %{issues: [%{...}], contributors: [%{...}]}}

      iex> issues_and_contributors("user", "repox")
      {:error, "Some error"}
  """

  def issues_and_contributors(user_name, repo_name) do
    issues_task = Task.async(fn -> Repos.get_issues_from_github(user_name, repo_name) end)

    contributor_task =
      Task.async(fn -> Repos.get_contributors_from_github(user_name, repo_name) end)

    issue_response = Task.await(issues_task)
    contributors_response = Task.await(contributor_task)

    handle_response(issue_response, contributors_response)
  end

  defp handle_response(issue_response, contributors_response) do
    case {issue_response, contributors_response} do
      {{:ok, issues}, {:ok, contributors}} ->
        {:ok, %{issues: issues, contributors: contributors}}

      {{:error, _} = error, _} ->
        error

      {_, {:error, _} = error} ->
        error
    end
  end
end
