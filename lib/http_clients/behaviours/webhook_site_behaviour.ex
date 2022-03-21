defmodule HttpClients.WebhookSiteBehaviour do
  @moduledoc false

  @type response ::
          {:ok, %Tesla.Env{status: 200..299, body: map()}}
          | {:error, %Tesla.Env{body: map()} | atom()}

  @callback post_webhook(any()) :: response()
end
