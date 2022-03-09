defmodule GithubServiceWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use GithubServiceWeb, :controller

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(GithubServiceWeb.ErrorView)
    |> render(:"404")
  end

  # This clause is an example of how to handle resources that throws parse errors.
  def call(conn, {:error, :parse_error}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(GithubServiceWeb.ErrorView)
    |> render("parse_error.json")
  end

  def call(conn, {:error, {status, message}}) when is_atom(status) do
    conn
    |> put_status(status)
    |> put_view(GithubServiceWeb.ErrorView)
    |> render("error.json", message: message)
  end

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(GithubServiceWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # Handles github not found response error
  def call(conn, {:error, %{"message" => "Not Found"}}) do
    call(conn, {:error, :not_found})
  end
end
