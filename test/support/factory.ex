defmodule GithubService.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: GithubService.Repo

  alias GithubService.Repos.{Contributor, Issue, Repository}

  alias Faker.{Lorem, Person}

  def repository_factory() do
    %Repository{
      user: Person.PtBr.name(),
      repository: Lorem.word(),
      issues: build_list(3, :issue),
      contributors: build_list(3, :contributor)
    }
  end

  def issue_factory() do
    %Issue{
      author: Person.PtBr.name(),
      labels: gen_labels(3),
      title: Lorem.word()
    }
  end

  def contributor_factory() do
    name = Person.PtBr.name()

    %Contributor{
      name: name,
      user: name,
      qtd_commits: 10
    }
  end

  def github_contributor_factory() do
    %{
      "login" => "josevalim",
      "id" => 9582,
      "node_id" => "MDQ6VXNlcjk1ODI=",
      "avatar_url" => "https =>//avatars.githubusercontent.com/u/9582?v=4",
      "gravatar_id" => "",
      "url" => "https =>//api.github.com/users/josevalim",
      "html_url" => "https =>//github.com/josevalim",
      "followers_url" => "https =>//api.github.com/users/josevalim/followers",
      "following_url" => "https =>//api.github.com/users/josevalim/following{/other_user}",
      "gists_url" => "https =>//api.github.com/users/josevalim/gists{/gist_id}",
      "starred_url" => "https =>//api.github.com/users/josevalim/starred{/owner}{/repo}",
      "subscriptions_url" => "https =>//api.github.com/users/josevalim/subscriptions",
      "organizations_url" => "https =>//api.github.com/users/josevalim/orgs",
      "repos_url" => "https =>//api.github.com/users/josevalim/repos",
      "events_url" => "https =>//api.github.com/users/josevalim/events{/privacy}",
      "received_events_url" => "https =>//api.github.com/users/josevalim/received_events",
      "type" => "User",
      "site_admin" => false,
      "contributions" => 10_190
    }
  end

  def github_issue_factory() do
    %{
      "url" => "https =>//api.github.com/repos/elixir-lang/elixir/issues/11651",
      "repository_url" => "https =>//api.github.com/repos/elixir-lang/elixir",
      "labels_url" =>
        "https =>//api.github.com/repos/elixir-lang/elixir/issues/11651/labels{/name}",
      "comments_url" => "https =>//api.github.com/repos/elixir-lang/elixir/issues/11651/comments",
      "events_url" => "https =>//api.github.com/repos/elixir-lang/elixir/issues/11651/events",
      "html_url" => "https =>//github.com/elixir-lang/elixir/issues/11651",
      "id" => 1_143_894_975,
      "node_id" => "I_kwDOABLXGs5ELnO_",
      "number" => 11_651,
      "title" =>
        "Pipe operator removes a function's import context if the import is outside a quote block",
      "user" => %{
        "login" => "polvalente",
        "id" => 16_843_419,
        "node_id" => "MDQ6VXNlcjE2ODQzNDE5",
        "avatar_url" => "https =>//avatars.githubusercontent.com/u/16843419?v=4",
        "gravatar_id" => "",
        "url" => "https =>//api.github.com/users/polvalente",
        "html_url" => "https =>//github.com/polvalente",
        "followers_url" => "https =>//api.github.com/users/polvalente/followers",
        "following_url" => "https =>//api.github.com/users/polvalente/following{/other_user}",
        "gists_url" => "https =>//api.github.com/users/polvalente/gists{/gist_id}",
        "starred_url" => "https =>//api.github.com/users/polvalente/starred{/owner}{/repo}",
        "subscriptions_url" => "https =>//api.github.com/users/polvalente/subscriptions",
        "organizations_url" => "https =>//api.github.com/users/polvalente/orgs",
        "repos_url" => "https =>//api.github.com/users/polvalente/repos",
        "events_url" => "https =>//api.github.com/users/polvalente/events{/privacy}",
        "received_events_url" => "https =>//api.github.com/users/polvalente/received_events",
        "type" => "User",
        "site_admin" => false
      },
      "labels" => [
        %{
          "id" => 207_974,
          "node_id" => "MDU6TGFiZWwyMDc5NzQ=",
          "url" => "https =>//api.github.com/repos/elixir-lang/elixir/labels/Kind =>Bug",
          "name" => "Kind =>Bug",
          "color" => "e10c02",
          "default" => false,
          "description" => nil
        },
        %{
          "id" => 1_000_549_131,
          "node_id" => "MDU6TGFiZWwxMDAwNTQ5MTMx",
          "url" =>
            "https =>//api.github.com/repos/elixir-lang/elixir/labels/App =>Elixir%20(compiler)",
          "name" => "App =>Elixir (compiler)",
          "color" => "CCCCCC",
          "default" => false,
          "description" => ""
        }
      ],
      "state" => "open",
      "locked" => false,
      "assignee" => nil,
      "assignees" => [],
      "milestone" => %{
        "url" => "https =>//api.github.com/repos/elixir-lang/elixir/milestones/30",
        "html_url" => "https =>//github.com/elixir-lang/elixir/milestone/30",
        "labels_url" => "https =>//api.github.com/repos/elixir-lang/elixir/milestones/30/labels",
        "id" => 7_596_652,
        "node_id" => "MI_kwDOABLXGs4Ac-ps",
        "number" => 30,
        "title" => "v1.14",
        "description" => "",
        "creator" => %{
          "login" => "josevalim",
          "id" => 9582,
          "node_id" => "MDQ6VXNlcjk1ODI=",
          "avatar_url" => "https =>//avatars.githubusercontent.com/u/9582?v=4",
          "gravatar_id" => "",
          "url" => "https =>//api.github.com/users/josevalim",
          "html_url" => "https =>//github.com/josevalim",
          "followers_url" => "https =>//api.github.com/users/josevalim/followers",
          "following_url" => "https =>//api.github.com/users/josevalim/following{/other_user}",
          "gists_url" => "https =>//api.github.com/users/josevalim/gists{/gist_id}",
          "starred_url" => "https =>//api.github.com/users/josevalim/starred{/owner}{/repo}",
          "subscriptions_url" => "https =>//api.github.com/users/josevalim/subscriptions",
          "organizations_url" => "https =>//api.github.com/users/josevalim/orgs",
          "repos_url" => "https =>//api.github.com/users/josevalim/repos",
          "events_url" => "https =>//api.github.com/users/josevalim/events{/privacy}",
          "received_events_url" => "https =>//api.github.com/users/josevalim/received_events",
          "type" => "User",
          "site_admin" => false
        },
        "open_issues" => 5,
        "closed_issues" => 3,
        "state" => "open",
        "created_at" => "2022-01-21T11 =>30 =>48Z",
        "updated_at" => "2022-03-06T13 =>07 =>45Z",
        "due_on" => "2022-05-31T07 =>00 =>00Z",
        "closed_at" => nil
      },
      "comments" => 0,
      "created_at" => "2022-02-18T22 =>52 =>58Z",
      "updated_at" => "2022-02-23T20 =>11 =>36Z",
      "closed_at" => nil,
      "author_association" => "CONTRIBUTOR",
      "active_lock_reason" => nil,
      "body" =>
        "### Environment\r\n\r\n* Elixir & Erlang/OTP versions (elixir --version) => Elixir 1.13.0, Erlang 24.1.5\r\n* Operating system => Ubuntu 20.04.3 LTS\r\n\r\n### Current behavior\r\n\r\nThe following code causes a compilation error related to `operation/3` being undefined.\r\n\r\n```elixir\r\ndefmodule MyMath do\r\n  def operation(fun, x, y), do => apply(fun, [x, y])\r\nend\r\n\r\ndefmodule MyMacro do\r\n  import MyMath\r\n\r\n  defmacro __using__(_) do\r\n    quote do\r\n      def add(x, y) do\r\n        add = &+/2\r\n\r\n        add |> operation(x, y)\r\n      end\r\n    end\r\n  end\r\nend\r\n\r\ndefmodule T do\r\n  use MyMacro\r\nend\r\n```\r\n\r\nThe code block below, however, has the import working as expected =>\r\n```elixir\r\ndefmodule MyMath do\r\n  def operation(fun, x, y), do => apply(fun, [x, y])\r\nend\r\n\r\ndefmodule MyMacro do\r\n  import MyMath\r\n\r\n  defmacro __using__(_) do\r\n    quote do\r\n      def add(x, y) do\r\n        add = &+/2\r\n\r\n        operation(add, x, y)\r\n      end\r\n    end\r\n  end\r\nend\r\n\r\ndefmodule T do\r\n  use MyMacro\r\nend\r\n```\r\n\r\n### Expected behavior\r\n\r\nI would expect the first snippet to be equivalent to the second one. Upon inspection of the AST, it seems that the pipe operator is removing the import context from the `{ =>operation, _, _}` node, which makes it try to resolve to `T`s namespace. This also seems to be why it works if the macro also forces the import upon the `T` module.",
      "reactions" => %{
        "url" => "https =>//api.github.com/repos/elixir-lang/elixir/issues/11651/reactions",
        "total_count" => 2,
        "+1" => 2,
        "-1" => 0,
        "laugh" => 0,
        "hooray" => 0,
        "confused" => 0,
        "heart" => 0,
        "rocket" => 0,
        "eyes" => 0
      },
      "timeline_url" => "https =>//api.github.com/repos/elixir-lang/elixir/issues/11651/timeline",
      "performed_via_github_app" => nil
    }
  end

  defp gen_labels(qnt), do: for(_ <- 0..qnt, do: Lorem.word())
end
