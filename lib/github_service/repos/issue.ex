defmodule GithubService.Repos.Issue do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias GithubService.Repos.Repository

  @fields ~w(author github_id labels title repository_id)a
  @required_fields ~w(author github_id labels title repository_id)a

  schema "issues" do
    field :author, :string
    field :github_id, :integer
    field :labels, {:array, :string}
    field :title, :string

    belongs_to :repository, Repository

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = issue, attrs) do
    issue
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
