defmodule GithubService.HttpClients do
  @moduledoc """
  The Http Clients context.
  """

  alias Utils.Handlers.Tesla

  @http_client Application.compile_env(
                 :github_service,
                 :webhook_site_client,
                 GithubService.HttpClients.WebhookSite
               )

  def post_to_webhook_site(data) do
    data
    |> @http_client.post_webhook
    |> Tesla.handle()
  end
end
