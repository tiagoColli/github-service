defmodule GithubServiceWeb.RepoControllerTest do
  @moduledoc false

  use GithubServiceWeb.ConnCase
  use Oban.Testing, repo: GithubService.Repo

  import Mox
  import GithubService.Factory

  alias GithubService.Repos
  alias GithubService.Repos.HttpClients.GithubMock
  alias GithubService.Repos.Workers.SendRepoWorker

  describe "fetch_repo_assync/2" do
    setup %{conn: conn} do
      github_issue_list = build_list(3, :github_issue)
      github_contributor_list = build_list(3, :github_contributor)
      conn = put_req_header(conn, "accept", "application/json")

      %{
        conn: conn,
        user: "some_user",
        repository: "some_repository",
        issues: github_issue_list,
        contributors: github_contributor_list
      }
    end

    test "with valid entries, fetch repo data, parses, save into database, schedule job and returns success",
         %{
           conn: conn,
           user: user,
           repository: repository,
           issues: issues,
           contributors: contributors
         } do
      http_attrs = %{"user" => user, "repository" => repository}

      expect(GithubMock, :list_repo_issues, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: issues}}
      end)

      expect(GithubMock, :list_repo_contributors, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: contributors}}
      end)

      route = Routes.repo_path(conn, :fetch_repo_assync)

      conn = get(conn, route, http_attrs)

      assert %{
               "message" => "Webhook scheduled with success",
               "repository_id" => repository_id,
               "scheduled_at" => scheduled_at
             } = json_response(conn, 200)

      refute nil == Repos.get_repository(repository_id)

      assert_enqueued(worker: SendRepoWorker, args: %{"repository_id" => repository_id})
    end

    test "with with non-existent user-repo combination, returns a not found error", %{conn: conn} do
      http_attrs = %{"user" => "non-existent", "repository" => "non-existent"}

      expect(GithubMock, :list_repo_issues, fn _, _ ->
        {:ok, %Tesla.Env{status: 404, body: %{"message" => "Not Found"}}}
      end)

      expect(GithubMock, :list_repo_contributors, fn _, _ ->
        {:ok, %Tesla.Env{status: 404, body: %{"message" => "Not Found"}}}
      end)

      route = Routes.repo_path(conn, :fetch_repo_assync)

      conn = get(conn, route, http_attrs)

      assert %{"errors" => %{"detail" => "Not Found"}} = json_response(conn, 404)

      refute_enqueued(worker: SendRepoWorker, args: %{})
    end

    test "with valid entries but invalid issue data when parsing, returns an error", %{
      conn: conn,
      user: user,
      repository: repository,
      contributors: contributors
    } do
      http_attrs = %{"user" => user, "repository" => repository}

      expect(GithubMock, :list_repo_issues, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: [%{invalid: "data"}]}}
      end)

      expect(GithubMock, :list_repo_contributors, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: contributors}}
      end)

      route = Routes.repo_path(conn, :fetch_repo_assync)

      conn = get(conn, route, http_attrs)

      assert %{"errors" => %{"detail" => "Error while parsing data"}} = json_response(conn, 500)

      refute_enqueued(worker: SendRepoWorker, args: %{})
    end

    test "with valid entries but invalid contributors data when parsing, returns an error", %{
      conn: conn,
      user: user,
      repository: repository,
      issues: issues
    } do
      http_attrs = %{"user" => user, "repository" => repository}

      expect(GithubMock, :list_repo_issues, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: issues}}
      end)

      expect(GithubMock, :list_repo_contributors, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: [%{invalid: "data"}]}}
      end)

      route = Routes.repo_path(conn, :fetch_repo_assync)

      conn = get(conn, route, http_attrs)

      assert %{"errors" => %{"detail" => "Error while parsing data"}} = json_response(conn, 500)

      refute_enqueued(worker: SendRepoWorker, args: %{})
    end
  end
end
