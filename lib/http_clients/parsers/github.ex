defmodule HttpClients.Parsers.Github do
  @moduledoc """
  Contains logic to parse github repositories public api responses.
  """

  @doc """
  Parses the response from github issue api to an Issue.

  ## Examples

      iex> parse_issue(%{title: "some_issue", labels: [%{name: "some_label"}], user: %{login: "some_author"}})
      {:ok, %{title: "some_issue", labels: ["some_label"], author: "some_author"}}

      iex> parse_issue(%{})
      {:error, :parse_error}
  """
  def parse_issue(issue) do
    case issue_have_all_keys?(issue) do
      true ->
        {:ok,
         %{
           title: issue["title"],
           labels: get_labels_name(issue["labels"]),
           author: issue["user"]["login"]
         }}

      false ->
        {:error, :parse_error}
    end
  end

  @doc """
  Parses a list of issues.
  """
  def parse_issues(issues) do
    issues
    |> reduce_issues_parsing()
    |> handle_reduce_parsing()
  end

  @doc """
  Parses the response from github contributor api to an Contributor.

  ## Examples

      iex> parse_contributor(%{name: "some_name", contributions: 123})
      {:ok, %{name: "some_name", user: "some_name", contributions: 123}}

      iex> parse_contributor(%{})
      {:error, :parse_error}
  """
  def parse_contributor(contributor) do
    case contributor_have_all_keys?(contributor) do
      true ->
        {:ok,
         %{
           name: contributor["login"],
           user: contributor["login"],
           qtd_commits: contributor["contributions"]
         }}

      false ->
        {:error, :parse_error}
    end
  end

  @doc """
  Parses a list of contributors.
  """
  def parse_contributors(contributors) do
    contributors
    |> reduce_contributors_parsing()
    |> handle_reduce_parsing()
  end

  defp issue_have_all_keys?(issue) do
    Map.has_key?(issue, "title") and Map.has_key?(issue, "labels") and Map.has_key?(issue, "user")
  end

  defp contributor_have_all_keys?(contributor) do
    Map.has_key?(contributor, "login") and Map.has_key?(contributor, "contributions")
  end

  defp get_labels_name(labels), do: Enum.map(labels, & &1["name"])

  defp reduce_issues_parsing(issues) do
    issues
    |> Enum.reduce_while([], fn issue, issue_list ->
      case parse_issue(issue) do
        {:ok, parsed_issue} -> {:cont, [parsed_issue | issue_list]}
        {:error, :parse_error} = error -> {:halt, error}
      end
    end)
  end

  defp reduce_contributors_parsing(contributors) do
    contributors
    |> Enum.reduce_while([], fn contributor, contributor_list ->
      case parse_contributor(contributor) do
        {:ok, parsed_contributor} -> {:cont, [parsed_contributor | contributor_list]}
        {:error, :parse_error} = error -> {:halt, error}
      end
    end)
  end

  defp handle_reduce_parsing(result) do
    case result do
      {:error, :parse_error} -> {:error, :parse_error}
      reduced_list -> {:ok, reduced_list}
    end
  end
end
