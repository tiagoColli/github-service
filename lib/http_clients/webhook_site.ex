defmodule HttpClients.WebhookSite do
  @moduledoc """
  Contains logic to make http calls to webhook site.
  """

  use Tesla

  @behaviour HttpClients.WebhookSiteBehaviour

  plug Tesla.Middleware.BaseUrl,
       Application.get_env(:github_service, :webhook_site_url) <>
         "/344880f8-5f2a-449a-8e35-8445cd001bdb"

  plug Tesla.Middleware.JSON

  @doc """
  Makes a call to the webhook site sending the given data.
  """
  def post_webhook(data), do: post("", data)
end
