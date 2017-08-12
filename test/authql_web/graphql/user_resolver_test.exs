defmodule AuthqlWeb.GraphQL.UserResolverTest do
  use AuthqlWeb.ConnCase
  alias AuthqlWeb.GraphQL.UserResolver

  test "resolves all users" do
    credentials = %{email: "x@y.com", password: "swordfish"}
    {:ok, user} = Authql.Auth.register_user(credentials)
    {:ok, session} = Authql.Auth.create_session(credentials)
    assert {:ok, [^user]} =
      UserResolver.all([], %{context: %{token: session.token}})
  end
end
