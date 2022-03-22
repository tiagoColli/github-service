defmodule HttpClients.Parsers.GithubTest do
  @moduledoc false

  use GithubService.DataCase

  import GithubService.Factory

  alias HttpClients.Parsers.Github

  describe "parse_issue/1" do
    test "when parse with success, return success with the parsed issue" do
      issue = build(:github_issue)

      assert {:ok,
              %{
                title:
                  "Pipe operator removes a function's import context if the import is outside a quote block",
                labels: ["Kind =>Bug", "App =>Elixir (compiler)"],
                author: "polvalente"
              }} = Github.parse_issue(issue)
    end

    test "when the parse fails, returns an error" do
      assert {:error, :parse_error} = Github.parse_issue(%{})
    end
  end

  describe "parse_issues/1" do
    test "when all issues in the list are parsed with success, return success with the parsed list" do
      issues = build_list(3, :github_issue)

      assert {:ok,
              [
                %{
                  title:
                    "Pipe operator removes a function's import context if the import is outside a quote block",
                  labels: ["Kind =>Bug", "App =>Elixir (compiler)"],
                  author: "polvalente"
                },
                %{
                  title:
                    "Pipe operator removes a function's import context if the import is outside a quote block",
                  labels: ["Kind =>Bug", "App =>Elixir (compiler)"],
                  author: "polvalente"
                },
                %{
                  title:
                    "Pipe operator removes a function's import context if the import is outside a quote block",
                  labels: ["Kind =>Bug", "App =>Elixir (compiler)"],
                  author: "polvalente"
                }
              ]} = Github.parse_issues(issues)
    end

    test "when some of the issues in the list fails, returns an error" do
      issues = build_list(3, :github_issue)

      assert {:error, :parse_error} = Github.parse_issues([%{} | issues])
    end
  end

  describe "parse_contributor/1" do
    test "when parse with success, return success with the parsed contributor" do
      contributor = build(:github_contributor)

      assert {:ok,
              %{
                name: "josevalim",
                user: "josevalim",
                qtd_commits: 10_190
              }} = Github.parse_contributor(contributor)
    end

    test "when the parse fails, returns an error" do
      assert {:error, :parse_error} = Github.parse_contributor(%{})
    end
  end

  describe "parse_contributors/1" do
    test "when all contributors in the list are parsed with success, return success with the parsed list" do
      contributors = build_list(3, :github_contributor)

      assert {:ok,
              [
                %{
                  name: "josevalim",
                  user: "josevalim",
                  qtd_commits: 10_190
                },
                %{
                  name: "josevalim",
                  user: "josevalim",
                  qtd_commits: 10_190
                },
                %{
                  name: "josevalim",
                  user: "josevalim",
                  qtd_commits: 10_190
                }
              ]} = Github.parse_contributors(contributors)
    end

    test "when the parse fails, returns an error" do
      contributors = build_list(3, :github_contributor)

      assert {:error, :parse_error} = Github.parse_contributors([%{} | contributors])
    end
  end
end
