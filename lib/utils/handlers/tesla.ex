defmodule Utils.Handlers.Tesla do
  @moduledoc """
  Contains logic to handle tesla http responses.
  """

  @success_status 200..299

  @doc """
  Handle tesla responses.

  ## Examples

      iex> handle({:ok, %{body: "some response", status: 200}})
      {:ok, "some response"}

      iex> handle({:ok, %{body: "error", status: 400}})
      {:error, "error"}

      iex> handle({:error, "error"})
      {:error, "error"}
  """
  def handle(response) do
    case response do
      {:ok, %{body: body, status: status}} when status in @success_status ->
        {:ok, body}

      {:ok, %{body: body}} ->
        {:error, body}

      {:error, _} = error ->
        error
    end
  end
end
