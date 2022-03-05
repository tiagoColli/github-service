defmodule GithubService.Repo do
  use Ecto.Repo,
    otp_app: :github_service,
    adapter: Ecto.Adapters.Postgres
end
