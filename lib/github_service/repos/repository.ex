defmodule GithubService.Repos.Repository do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias GithubService.Repos.{Contributor, Issue}

  @fields ~w(repository user)a
  @required_fields ~w(repository user)a

  @derive {Jason.Encoder, only: [:repository, :user, :contributors, :issues]}
  schema "repositories" do
    field :repository, :string
    field :user, :string

    embeds_many :contributors, Contributor
    embeds_many :issues, Issue

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = repository, attrs) do
    repository
    |> cast(attrs, @fields)
    |> cast_embed(:issues)
    |> cast_embed(:contributors)
    |> validate_required(@required_fields)
  end
end
