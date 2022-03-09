defmodule GithubService.HttpClients.WebhookSite do
  @moduledoc """
  Contains logic to make http calls to webhook site.
  """

  use Tesla

  @behaviour GithubService.HttpClients.WebhookSiteBehaviour

  plug Tesla.Middleware.BaseUrl,
       Application.get_env(:github_service, :webhook_site_url) <>
         "/87fe7745-4622-48fe-80b0-a00aed7f2818"

  plug Tesla.Middleware.JSON

  @doc """
  Makes a call to the webhook site sending the given data.
  """
  def post_webhook(data), do: post("", data)
end
