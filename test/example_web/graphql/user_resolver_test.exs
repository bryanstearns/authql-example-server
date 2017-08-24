defmodule ExampleWeb.GraphQL.UserResolverTest do
  use Example.DataCase
  alias ExampleWeb.GraphQL.UserResolver

  test "resolves all users" do
    credentials = %{email: "x@y.com", password: "swordfish"}
    {:ok, user} = Authql.register_user(credentials)
    {:ok, session} = Authql.create_session(Map.put(credentials, :expires_at, nil))
    assert {:ok, [^user]} =
      UserResolver.all(%{viewer: Integer.to_string(session.user_id)}, %{context: %{token: session.token}})
  end
end
