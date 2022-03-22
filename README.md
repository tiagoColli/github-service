[![Elixir CI](https://github.com/tiagoColli/github-service/actions/workflows/elixir.yml/badge.svg)](https://github.com/tiagoColli/github-service/actions/workflows/elixir.yml)

[![Coverage](https://coveralls.io/repos/github/tiagoColli/github-service/badge.svg?branch=master)](https://coveralls.io/github/tiagoColli/github-service?branch=master)

# GithubService

## Objetivo

Repositório destinado a implementação do case técnico da Swap.

## Projeto

O projeto tem como objetivo recuperar dados da api do github, salva-los no banco de dados e envia-los através de um webhook.
O fluxo completo pode ser acionado através da rota `/api/repo_assync`.

## Melhorias indicadas

- Adicionar logs e ferramentas monitoramento (sentry para monitoramento de erros e honeycomb para tracing distribuidos das chamadas externas) para trackear eventos e possíveis error.
- Melhorar o tratamento de erros nos controllers através do fallback controller.
- Refatorar o módulo `github_parser.ex` para ser mais genérico (muitos itens hard coded).

## Para rodar o projeto

- `mix deps.get`
- `mix ecto.setup`
- `mix phx.server`