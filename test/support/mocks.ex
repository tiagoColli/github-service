import Mox

defmock(GithubService.Repos.HttpClients.GithubMock,
  for: GithubService.Repos.HttpClients.GithubBehaviour
)

defmock(GithubService.HttpClients.WebhookSiteMock,
  for: GithubService.HttpClients.WebhookSiteBehaviour
)
