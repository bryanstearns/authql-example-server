defmodule AuthqlWeb.GraphQL.SessionResolverTest do
  use AuthqlWeb.ConnCase
  alias Authql.Auth.Session
  alias AuthqlWeb.GraphQL.SessionResolver

  test "creates a session when the email/password are good" do
    {:ok, _user} = Authql.Auth.register_user(%{email: "x@y.com",
                                               password: "swordfish"})
    assert {:ok, %Session{user: %{email: "x@y.com"}, token: _}} =
      SessionResolver.login(%{email: "x@y.com", password: "swordfish"}, [])
  end

  test "returns an error when the email/password are bad" do
    assert {:error, _message} =
      SessionResolver.login(%{email: "user@example.com", password: "sekrit"}, [])
  end
end
