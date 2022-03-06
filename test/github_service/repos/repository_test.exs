defmodule GithubService.Repos.RepositoryTest do
  @moduledoc false

  use GithubService.DataCase

  alias Faker.Lorem
  alias GithubService.Repos.Repository

  describe "changeset/2" do
    test "when the given params are valid, returns a valid changeset" do
      new_repository = %{
        repository: Lorem.word(),
        user: Lorem.word()
      }

      assert %{valid?: true} = Repository.changeset(%Repository{}, new_repository)
    end

    test "when the given params are not valid, raises an exception" do
      new_repository = %{}

      assert_raise FunctionClauseError, fn ->
        Repository.changeset(new_repository, new_repository)
      end
    end

    test "when the attrs type are not valid, returns an invalid changeset with the errors" do
      new_repository = %{repository: 123, user: 123}

      assert %{valid?: false} = changeset = Repository.changeset(%Repository{}, new_repository)

      assert "is invalid" in errors_on(changeset).repository
      assert "is invalid" in errors_on(changeset).user
    end

    test "when required attrs are not filled, returns an invalid changeset with the errors" do
      new_repository = %{}

      assert %{valid?: false} = changeset = Repository.changeset(%Repository{}, new_repository)

      assert errors_on(changeset) == %{
               repository: ["can't be blank"],
               user: ["can't be blank"]
             }
    end
  end
end
