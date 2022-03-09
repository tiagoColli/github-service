defmodule GithubService.Repos.IssueTest do
  @moduledoc false

  use GithubService.DataCase

  alias Faker.Lorem
  alias GithubService.Repos.Issue

  describe "changeset/2" do
    test "when the given params are valid, returns a valid changeset" do
      new_issue = %{
        author: Lorem.word(),
        labels: [Lorem.word(), Lorem.word()],
        title: Lorem.word()
      }

      assert %{valid?: true} = Issue.changeset(%Issue{}, new_issue)
    end

    test "when the attrs type are not valid, returns an invalid changeset with the errors" do
      new_issue = %{
        author: 123,
        labels: Lorem.word(),
        title: 123
      }

      assert %{valid?: false} = changeset = Issue.changeset(%Issue{}, new_issue)

      assert "is invalid" in errors_on(changeset).author
      assert "is invalid" in errors_on(changeset).labels
      assert "is invalid" in errors_on(changeset).title
    end

    test "when the label type inside the list are not valid, returns an invalid changeset with the errors" do
      new_issue = %{labels: [123, 123]}

      assert %{valid?: false} = changeset = Issue.changeset(%Issue{}, new_issue)

      assert "is invalid" in errors_on(changeset).labels
    end

    test "when required attrs are not filled, returns an invalid changeset with the errors" do
      new_issue = %{}

      assert %{valid?: false} = changeset = Issue.changeset(%Issue{}, new_issue)

      assert errors_on(changeset) == %{
               author: ["can't be blank"],
               labels: ["can't be blank"],
               title: ["can't be blank"]
             }
    end
  end
end
