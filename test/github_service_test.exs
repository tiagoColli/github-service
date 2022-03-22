defmodule GithubServiceTest do
  @moduledoc false

  use GithubService.DataCase
  use Oban.Testing, repo: GithubService.Repo

  import Mox
  import GithubService.Factory

  alias GithubService.Repos
  alias GithubService.Repos.Repository
  alias GithubService.Repos.Workers.SendRepoWorker
  alias HttpClients.GithubMock

  describe "fetch_repo_assync/2" do
    setup do
      github_issue_list = build_list(3, :github_issue)
      github_contributor_list = build_list(3, :github_contributor)

      %{
        user: "some_user",
        repository: "some_repository",
        issues: github_issue_list,
        contributors: github_contributor_list
      }
    end

    test "with valid entries, fetch repo data, parses, save into database, schedule job and returns success",
         %{
           user: user,
           repository: repository,
           issues: issues,
           contributors: contributors
         } do
      expect(GithubMock, :list_repo_issues, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: issues}}
      end)

      expect(GithubMock, :list_repo_contributors, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: contributors}}
      end)

      assert {:ok,
              %{
                repository_id: repository_id,
                scheduled_at: _scheduled_at
              }} = GithubService.fetch_repo_assync(user, repository)

      assert %Repository{} = Repos.get_repository(repository_id)

      assert_enqueued(worker: SendRepoWorker, args: %{"repository_id" => repository_id})
    end

    test "with with non-existent user-repo combination, returns a not found error" do
      expect(GithubMock, :list_repo_issues, fn _, _ ->
        {:ok, %Tesla.Env{status: 404, body: %{"message" => "Not Found"}}}
      end)

      expect(GithubMock, :list_repo_contributors, fn _, _ ->
        {:ok, %Tesla.Env{status: 404, body: %{"message" => "Not Found"}}}
      end)

      assert {:error, %{"message" => "Not Found"}} =
               GithubService.fetch_repo_assync("non-existent", "non-existent")

      refute_enqueued(worker: SendRepoWorker, args: %{})
    end

    test "with valid entries but invalid issue data when parsing, returns an error", %{
      user: user,
      repository: repository,
      contributors: contributors
    } do
      expect(GithubMock, :list_repo_issues, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: [%{invalid: "data"}]}}
      end)

      expect(GithubMock, :list_repo_contributors, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: contributors}}
      end)

      assert {:error, :parse_error} = GithubService.fetch_repo_assync(user, repository)

      refute_enqueued(worker: SendRepoWorker, args: %{})
    end

    test "with valid entries but invalid contributors data when parsing, returns an error", %{
      user: user,
      repository: repository,
      issues: issues
    } do
      expect(GithubMock, :list_repo_issues, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: issues}}
      end)

      expect(GithubMock, :list_repo_contributors, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: [%{invalid: "data"}]}}
      end)

      assert {:error, :parse_error} = GithubService.fetch_repo_assync(user, repository)

      refute_enqueued(worker: SendRepoWorker, args: %{})
    end
  end
end
