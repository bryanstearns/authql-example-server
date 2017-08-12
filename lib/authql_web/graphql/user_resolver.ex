defmodule AuthqlWeb.GraphQL.UserResolver do
  def all(_args, %{context: %{token: token}}) do
    if Authql.Auth.token_valid?(token) do
      {:ok, Authql.Auth.list_users()}
    else
      unauthorized_error()
    end
  end
  def all(_args, _info) do
    unauthorized_error()
  end

  defp unauthorized_error do
    {:error, %{code: :unauthorized,
               error: "Unauthorized",
               message: "Unauthorized"}}
  end
end
