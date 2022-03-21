import Mox

defmock(HttpClients.GithubMock, for: HttpClients.GithubBehaviour)
defmock(HttpClients.WebhookSiteMock, for: HttpClients.WebhookSiteBehaviour)
