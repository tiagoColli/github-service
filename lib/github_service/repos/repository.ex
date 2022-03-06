defmodule GithubService.Repos.Repository do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias GithubService.Repos.{Contributor, Issue}

  @fields ~w(repository user)a
  @required_fields ~w(repository user)a

  schema "repos" do
    field :repository, :string
    field :user, :string

    has_many :issues, Issue, foreign_key: :repository_id
    has_many :contributor, Contributor, foreign_key: :repository_id

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = repo, attrs) do
    repo
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
