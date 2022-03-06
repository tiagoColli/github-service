defmodule GithubService.Repos.Contributor do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias GithubService.Repos.Repository

  @fields ~w(github_id name qtd_commits user repository_id)a
  @required_fields ~w(github_id name qtd_commits user repository_id)a

  schema "contributors" do
    field :github_id, :integer
    field :name, :string
    field :qtd_commits, :integer
    field :user, :string

    belongs_to :repository, Repository

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = contributor, attrs) do
    contributor
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
