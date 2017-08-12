defmodule AuthqlWeb.ContextTest do
  use AuthqlWeb.ConnCase

  alias Authql.Auth
  alias AuthqlWeb.Context

  test "it records the token when it's present", %{conn: conn} do
    credentials = %{email: "a@b.com", password: "swordfish"}
    {:ok, _user} = Auth.register_user(credentials)
    {:ok, %{token: token}} = Auth.create_session(credentials)

    conn = %{conn | req_headers: [{"authorization", "Bearer #{token}"}]}
    |> Context.call()

    assert %{context: %{token: ^token}} = conn.private.absinthe
  end

  test "it doesn't note a token when not present", %{conn: conn} do
    conn = Context.call(conn)
    refute Map.has_key?(conn.private, :absinthe)
  end
end
