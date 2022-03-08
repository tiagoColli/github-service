defmodule GithubService.Repos.Contributor do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(name qtd_commits user)a
  @required_fields ~w(name qtd_commits user)a

  @derive {Jason.Encoder, only: [:name, :qtd_commits, :user]}
  @primary_key false
  embedded_schema do
    field :name, :string
    field :qtd_commits, :integer
    field :user, :string
  end

  @doc false
  def changeset(%__MODULE__{} = contributor, attrs) do
    contributor
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
