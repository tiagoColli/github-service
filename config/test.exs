import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :github_service, GithubService.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "github_service_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# Configure the database for GitHub Actions
if System.get_env("GITHUB_ACTIONS") do
  config :app, App.Repo,
    username: "postgres",
    password: "postgres"
end

# Oban configs for tested
config :github_service, Oban, queues: false, plugins: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :github_service, GithubServiceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "kfqbx6n3/1fIXCNKxK3zti8IjHciZtq9U4zlQKYUBp7zXu6+I3icmPpY3llzhDaD",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Set test env to get mock
config :github_service, github_http_client: HttpClients.GithubMock
config :github_service, webhook_site_client: HttpClients.WebhookSiteMock
