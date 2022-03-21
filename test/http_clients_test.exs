defmodule HttpClientsTest do
  @moduledoc false

  use GithubService.DataCase

  import GithubService.Factory
  import Mox

  alias HttpClients.{GithubMock, WebhookSiteMock}

  describe "post_to_webhook_site/2" do
    test "when the given data sent sucessfull, returns the success status" do
      expect(WebhookSiteMock, :post_webhook, fn _ ->
        {:ok, %Tesla.Env{status: 200, body: "response"}}
      end)

      assert {:ok, "response"} == HttpClients.post_to_webhook_site(%{some_data: "some_data"})
    end

    test "when the post send with success but returns an error status, returns the error" do
      expect(WebhookSiteMock, :post_webhook, fn _ ->
        {:ok, %Tesla.Env{status: 500, body: "error"}}
      end)

      assert {:error, "error"} == HttpClients.post_to_webhook_site(%{some_data: "some_data"})
    end

    test "when the call returns an error, returns an error" do
      expect(WebhookSiteMock, :post_webhook, fn _ -> {:error, :error} end)

      assert {:error, :error} == HttpClients.post_to_webhook_site(%{some_data: "some_data"})
    end
  end

  describe "get_issues_from_github/2" do
    test "when the given user-repo combination exists, returns the issues with success" do
      github_issue_list = build_list(3, :github_issue)

      expect(GithubMock, :list_repo_issues, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: github_issue_list}}
      end)

      assert {:ok, github_issue_list} == HttpClients.get_issues_from_github("user", "repository")
    end

    test "when the given user-repo combination dont exists, returns an not found error with message" do
      expect(GithubMock, :list_repo_issues, fn _, _ ->
        {:ok, %Tesla.Env{status: 404, body: %{"message" => "Not Found"}}}
      end)

      assert {:error, %{"message" => "Not Found"}} ==
               HttpClients.get_issues_from_github("user", "repository")
    end

    test "when the call returns an error, returns an error" do
      expect(GithubMock, :list_repo_issues, fn _, _ -> {:error, :error} end)

      assert {:error, :error} == HttpClients.get_issues_from_github("user", "repository")
    end
  end

  describe "get_contributors_from_github/2" do
    test "when the given user-repo combination exists, returns the contributors with success" do
      github_contributor_list = build_list(3, :github_contributor)

      expect(GithubMock, :list_repo_contributors, fn _, _ ->
        {:ok, %Tesla.Env{status: 200, body: github_contributor_list}}
      end)

      assert {:ok, github_contributor_list} ==
               HttpClients.get_contributors_from_github("user", "repository")
    end

    test "when the given user-repo combination dont exists, returns an not found error with message" do
      expect(GithubMock, :list_repo_contributors, fn _, _ ->
        {:ok, %Tesla.Env{status: 404, body: %{"message" => "Not Found"}}}
      end)

      assert {:error, %{"message" => "Not Found"}} ==
               HttpClients.get_contributors_from_github("user", "repository")
    end

    test "when the call returns an error, returns an error" do
      expect(GithubMock, :list_repo_contributors, fn _, _ -> {:error, :error} end)

      assert {:error, :error} == HttpClients.get_contributors_from_github("user", "repository")
    end
  end
end
