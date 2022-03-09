defmodule GithubService.Repos.RepositoryTest do
  @moduledoc false

  use GithubService.DataCase

  import GithubService.Factory

  alias Faker.Lorem
  alias GithubService.Repos.Repository

  describe "changeset/2" do
    test "when the given params are valid, returns a valid changeset" do
      new_repository = %{
        repository: Lorem.word(),
        user: Lorem.word(),
        issues: build_list(3, :issue_map),
        contributors: build_list(3, :contributor_map)
      }

      assert %{valid?: true} = Repository.changeset(%Repository{}, new_repository)
    end

    test "when the attrs type are not valid, returns an invalid changeset with the errors" do
      new_repository = %{repository: 123, user: 123, issues: 123, contributors: 123}

      assert %{valid?: false} = changeset = Repository.changeset(%Repository{}, new_repository)

      assert "is invalid" in errors_on(changeset).repository
      assert "is invalid" in errors_on(changeset).user
      assert "is invalid" in errors_on(changeset).issues
      assert "is invalid" in errors_on(changeset).contributors
    end

    test "when the attrs type of embed schemas are not filled, returns an invalid changeset with the errors" do
      new_repository = %{
        repository: Lorem.word(),
        user: Lorem.word(),
        issues: [%{}],
        contributors: [%{}]
      }

      assert %{valid?: false} = changeset = Repository.changeset(%Repository{}, new_repository)

      assert errors_on(changeset) == %{
               contributors: [
                 %{
                   name: ["can't be blank"],
                   qtd_commits: ["can't be blank"],
                   user: ["can't be blank"]
                 }
               ],
               issues: [
                 %{
                   author: ["can't be blank"],
                   labels: ["can't be blank"],
                   title: ["can't be blank"]
                 }
               ]
             }
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
