defmodule GithubServiceWeb.Router do
  use GithubServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GithubServiceWeb do
    pipe_through :api
  end
end
