defmodule GithubService.Repos.ContributorTest do
  @moduledoc false

  use GithubService.DataCase

  alias Faker.Lorem
  alias GithubService.Repos.Contributor

  describe "changeset/2" do
    test "when the given params are valid, returns a valid changeset" do
      new_contributor = %{
        github_id: 123,
        name: Lorem.word(),
        qtd_commits: 10,
        user: Lorem.word(),
        repository_id: 123
      }

      assert %{valid?: true} = Contributor.changeset(%Contributor{}, new_contributor)
    end

    test "when the given params are not valid, raises an exception" do
      new_contributor = %{}

      assert_raise FunctionClauseError, fn ->
        Contributor.changeset(new_contributor, new_contributor)
      end
    end

    test "when the attrs type are not valid, returns an invalid changeset with the errors" do
      new_contributor = %{
        github_id: Lorem.word(),
        name: 123,
        qtd_commits: Lorem.word(),
        user: 123,
        repository_id: Lorem.word()
      }

      assert %{valid?: false} = changeset = Contributor.changeset(%Contributor{}, new_contributor)

      assert "is invalid" in errors_on(changeset).github_id
      assert "is invalid" in errors_on(changeset).name
      assert "is invalid" in errors_on(changeset).qtd_commits
      assert "is invalid" in errors_on(changeset).user
      assert "is invalid" in errors_on(changeset).repository_id
    end

    test "when required attrs are not filled, returns an invalid changeset with the errors" do
      new_contributor = %{}

      assert %{valid?: false} = changeset = Contributor.changeset(%Contributor{}, new_contributor)

      assert errors_on(changeset) == %{
               github_id: ["can't be blank"],
               name: ["can't be blank"],
               qtd_commits: ["can't be blank"],
               user: ["can't be blank"],
               repository_id: ["can't be blank"]
             }
    end
  end
end
