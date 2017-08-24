defmodule ExampleWeb.GraphQL.UserResolver do

  def all(args, info) do
    Authql.if_authenticated(args, info, fn _user_id ->
      {:ok, Authql.list_users()}
    end)
  end

  def one(args, info) do
    Authql.if_authenticated(args, info, fn user_id ->
      {:ok, Authql.get_user!(user_id)}
    end)
  end
end
