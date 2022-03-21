defmodule GithubService.Repos.Workers.SendRepoWorkerTest do
  @moduledoc false

  use GithubService.DataCase
  use Oban.Testing, repo: GithubService.Repo

  import Mox
  import GithubService.Factory

  alias GithubService.Repos.Workers.SendRepoWorker
  alias HttpClients.WebhookSiteMock

  describe "perform/1" do
    setup do
      %{id: repository_id} = insert(:repository)
      %{repository_id: repository_id}
    end

    test "when the repository data exists and the data is send with success, returns a success tuple",
         %{repository_id: repository_id} do
      attrs = %{repository_id: repository_id}

      expect(WebhookSiteMock, :post_webhook, fn _ ->
        {:ok, %Tesla.Env{status: 200, body: "success"}}
      end)

      assert {:ok, "success"} = perform_job(SendRepoWorker, attrs)
    end

    test "when the call is made but with 500 status, returns the error", %{
      repository_id: repository_id
    } do
      mock_body = %{"errors" => %{"detail" => "Internal server error"}}
      attrs = %{repository_id: repository_id}

      expect(WebhookSiteMock, :post_webhook, fn _ ->
        {:ok, %Tesla.Env{status: 500, body: mock_body}}
      end)

      assert {:error, mock_body} = perform_job(SendRepoWorker, attrs)
    end

    test "when the call is made but with 400 status, returns the error", %{
      repository_id: repository_id
    } do
      mock_body = %{"errors" => %{"detail" => "Bad Request"}}
      attrs = %{repository_id: repository_id}

      expect(WebhookSiteMock, :post_webhook, fn _ ->
        {:ok, %Tesla.Env{status: 400, body: mock_body}}
      end)

      assert {:error, mock_body} = perform_job(SendRepoWorker, attrs)
    end

    test "returns an error when connection times out", %{repository_id: repository_id} do
      attrs = %{repository_id: repository_id}

      expect(WebhookSiteMock, :post_webhook, fn _ -> {:error, :timeout} end)

      assert {:error, :timeout} == perform_job(SendRepoWorker, attrs)
    end

    test "returns an error when the server is unavailable", %{repository_id: repository_id} do
      attrs = %{repository_id: repository_id}

      expect(WebhookSiteMock, :post_webhook, fn _ -> {:error, :unavailable} end)

      assert {:error, :unavailable} == perform_job(SendRepoWorker, attrs)
    end
  end
end
