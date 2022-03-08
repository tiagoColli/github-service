defmodule GithubService.Repos.Issue do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(author labels title)a
  @required_fields ~w(author labels title)a

  @derive {Jason.Encoder, only: [:author, :labels, :title]}
  @primary_key false
  embedded_schema do
    field :author, :string
    field :labels, {:array, :string}
    field :title, :string
  end

  @doc false
  def changeset(%__MODULE__{} = issue, attrs) do
    issue
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
