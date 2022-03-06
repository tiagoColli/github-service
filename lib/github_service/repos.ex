defmodule GithubService.Repos do
  @moduledoc """
  The Repos context.
  """

  import Ecto.Query, warn: false
  alias GithubService.Repo

  alias GithubService.Repos.Repository

  @doc """
  Returns the list of repositories.

  ## Examples

      iex> list_repositories()
      [%Repo{}, ...]

  """
  def list_repositories do
    Repo.all(Repository)
  end
end
