defmodule HttpClients do
  @moduledoc """
  The Http Clients context.
  """

  alias HttpClients.FetchAssync
  alias Utils.Handlers.Tesla

  @webhook_site_http_client Application.compile_env(
                              :github_service,
                              :webhook_site_client,
                              HttpClients.WebhookSite
                            )

  @github_http_client Application.compile_env(
                        :github_service,
                        :github_http_client,
                        HttpClients.Github
                      )

  def post_to_webhook_site(data) do
    data
    |> @webhook_site_http_client.post_webhook
    |> Tesla.handle()
  end

  def get_issues_from_github(user_name, repo_name) do
    user_name
    |> @github_http_client.list_repo_issues(repo_name)
    |> Tesla.handle()
  end

  def get_contributors_from_github(user_name, repo_name) do
    user_name
    |> @github_http_client.list_repo_contributors(repo_name)
    |> Tesla.handle()
  end

  defdelegate fetch_repo_assync(user_name, repo_name),
    to: FetchAssync,
    as: :issues_and_contributors
end
