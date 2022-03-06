defmodule GithubService.Repos.Repository do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(repository user)a
  @required_fields ~w(repository user)a

  schema "repos" do
    field :repository, :string
    field :user, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = repo, attrs) do
    repo
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
