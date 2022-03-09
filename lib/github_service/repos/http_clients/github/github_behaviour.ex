defmodule GithubService.Repos.HttpClients.GithubBehaviour do
  @moduledoc false

  @type response ::
          {:ok, %Tesla.Env{status: 200..299, body: map() | list()}}
          | {:error, %Tesla.Env{body: map()} | atom()}

  @callback list_repo_issues(String, String) :: response()
  @callback list_repo_contributors(String, String) :: response()
end
