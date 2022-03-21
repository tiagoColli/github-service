defmodule HttpClients.FetchAssync do
  @moduledoc """
  Contains logic to fetch data assync from github.
  """

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
    user_name
    |> issues_and_contributors_tasks(repo_name)
    |> Task.await_many()
    |> handle_response()
  end

  defp issues_and_contributors_tasks(user_name, repo_name) do
    issues_task = Task.async(fn -> HttpClients.get_issues_from_github(user_name, repo_name) end)

    contributor_task =
      Task.async(fn -> HttpClients.get_contributors_from_github(user_name, repo_name) end)

    [issues_task, contributor_task]
  end

  defp handle_response([issue_response, contributors_response]) do
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
