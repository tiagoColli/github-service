# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :github_service,
  ecto_repos: [GithubService.Repo]

# Configures oban workers
config :github_service, Oban,
  repo: GithubService.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, events: 50, media: 20]

# Configures the endpoint
config :github_service, GithubServiceWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: GithubServiceWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: GithubService.PubSub,
  live_view: [signing_salt: "rKb9P4El"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Github base api URL
config :github_service,
  github_base_api: "https://api.github.com",
  webhook_site_url: "https://webhook.site"

if Mix.env() == :dev do
  config :git_hooks,
    verbose: true,
    auto_install: false,
    hooks: [
      pre_commit: [
        tasks: [
          {:cmd, "mix compile --warnings-as-errors"},
          {:cmd, "mix format --check-formatted"},
          {:cmd, "mix credo --strict"},
          {:cmd, "mix test"}
        ]
      ]
    ]
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
