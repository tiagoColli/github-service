defmodule GithubService.ReposTest do
  @moduledoc false

  use GithubService.DataCase

  use Oban.Testing, repo: GithubService.Repo

  import GithubService.Factory

  alias Faker.{Lorem, Person}
  alias GithubService.Repos
  alias GithubService.Repos.Repository
  alias GithubService.Repos.Workers.SendRepoWorker

  describe "insert_repository/1" do
    test "when the given params are valid, inserts the repository into db and returns success" do
      repository = build(:repository_map)
      assert {:ok, _} = Repos.insert_repository(repository)
    end

    test "when the given params are invalid, returns an error with the changeset" do
      repository = %{}
      assert {:error, %Ecto.Changeset{}} = Repos.insert_repository(repository)
    end
  end

  describe "get_repository/1" do
    test "when the given id exists, returns the repository" do
      %{id: repository_id} = insert(:repository)
      assert %Repository{} = Repos.get_repository(repository_id)
    end

    test "when the given id dont exists, returns nil" do
      assert nil == Repos.get_repository(123)
    end
  end

  describe "parse_and_build_repository/4" do
    setup do
      user = Person.PtBr.name()
      repository = Lorem.word()
      issues = build_list(3, :github_issue)
      contributors = build_list(3, :github_contributor)

      %{user: user, repository: repository, issues: issues, contributors: contributors}
    end

    test "when the given params are valid, returns the repository map", %{
      user: user,
      repository: repository,
      issues: issues,
      contributors: contributors
    } do
      assert {:ok,
              %{
                contributors: [
                  %{name: "josevalim", qtd_commits: 10_190, user: "josevalim"},
                  %{name: "josevalim", qtd_commits: 10_190, user: "josevalim"},
                  %{name: "josevalim", qtd_commits: 10_190, user: "josevalim"}
                ],
                issues: [
                  %{
                    author: "polvalente",
                    labels: ["Kind =>Bug", "App =>Elixir (compiler)"],
                    title:
                      "Pipe operator removes a function's import context if the import is outside a quote block"
                  },
                  %{
                    author: "polvalente",
                    labels: ["Kind =>Bug", "App =>Elixir (compiler)"],
                    title:
                      "Pipe operator removes a function's import context if the import is outside a quote block"
                  },
                  %{
                    author: "polvalente",
                    labels: ["Kind =>Bug", "App =>Elixir (compiler)"],
                    title:
                      "Pipe operator removes a function's import context if the import is outside a quote block"
                  }
                ],
                repository: repository,
                user: user
              }} == Repos.parse_and_build_repository(user, repository, issues, contributors)
    end

    test "when the given issue params are invalid, returns an parse error", %{
      user: user,
      repository: repository,
      contributors: contributors
    } do
      issues = [%{}, %{}, %{}]

      assert {:error, :parse_error} ==
               Repos.parse_and_build_repository(user, repository, issues, contributors)
    end

    test "when the given contributor params are invalid, returns an parse error", %{
      user: user,
      repository: repository,
      issues: issues
    } do
      contributors = [%{}, %{}, %{}]

      assert assert {:error, :parse_error} ==
                      Repos.parse_and_build_repository(user, repository, issues, contributors)
    end
  end

  describe "schedule_repo_send/1" do
    test "when the given params valid, returns success and schedule the job" do
      id = 123

      {:ok, _} = Repos.schedule_repo_send(id)

      assert_enqueued(
        worker: SendRepoWorker,
        args: %{"repository_id" => id}
      )
    end
  end
end
