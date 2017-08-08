defmodule AuthqlWeb.GraphQL.UserResolver do
  def all(_args, _info) do
    {:ok, Authql.Auth.list_users()}
  end
end
