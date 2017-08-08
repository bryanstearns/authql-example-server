defmodule AuthqlWeb.GraphQL.UserResolverTest do
  use AuthqlWeb.ConnCase
  alias AuthqlWeb.GraphQL.UserResolver

  test "resolves all users" do
    {:ok, user} = Authql.Auth.register_user(%{email: "x@y.com",
                                              password: "swordfish"})
    assert {:ok, [^user]} = UserResolver.all([], [])
  end
end
