defmodule GithubService.Repos.FetchAssyncTest do
  @moduledoc false

  use GithubService.DataCase

  import Mox

  alias GithubService.Repos.FetchAssync
  alias GithubService.Repos.HttpClients.GithubMock

  describe "issues_and_contributors/2" do
    test "when everything works ok, returns success with both api responses" do
      expect(GithubMock, :list_repo_issues, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: [%{issue1: "issue1"}, %{issue2: "issue2"}]}}
      end)

      expect(GithubMock, :list_repo_contributors, fn _, _ ->
        {:ok,
         %Tesla.Env{
           status: 200,
           body: [%{contributor1: "contributor1"}, %{contributor2: "contributor2"}]
         }}
      end)

      assert {:ok,
              %{
                issues: [%{issue1: "issue1"}, %{issue2: "issue2"}],
                contributors: [%{contributor1: "contributor1"}, %{contributor2: "contributor2"}]
              }} = FetchAssync.issues_and_contributors("some_user", "some_repo")
    end

    test "when the call to issues api returns an error, returns the error" do
      expect(GithubMock, :list_repo_issues, fn _, _ ->
        {:error, :issue_error}
      end)

      expect(GithubMock, :list_repo_contributors, fn _, _ ->
        {:ok,
         %Tesla.Env{
           status: 200,
           body: [%{contributor1: "contributor1"}, %{contributor2: "contributor2"}]
         }}
      end)

      assert {:error, :issue_error} =
               FetchAssync.issues_and_contributors("some_user", "some_repo")
    end

    test "when the call to contributors api returns an error, returns the error" do
      expect(GithubMock, :list_repo_issues, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: [%{issue1: "issue1"}, %{issue2: "issue2"}]}}
      end)

      expect(GithubMock, :list_repo_contributors, fn _, _ ->
        {:error, :contributor_error}
      end)

      assert {:error, :contributor_error} =
               FetchAssync.issues_and_contributors("some_user", "some_repo")
    end
  end
end
