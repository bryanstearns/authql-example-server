defmodule Authql.Auth.SessionTest do
  use Authql.DataCase
  alias Authql.Auth
  alias Authql.Auth.Session

  test "happy-path session lifecycle" do
    credentials = %{email: "x@y.com", password: "swordfish"}
    {:ok, _user} = Auth.register_user(credentials)

    # create
    assert {:ok, session} = Session.create(credentials.email, credentials.password)
    assert %Session{user: %{email: "x@y.com"}, token: token} = session

    # get
    assert {:ok, ^session} = Session.get(token)

    # delete
    assert {:ok, ^session} = Session.delete(token)

    # make sure it's gone
    assert {:error, :not_found} = Session.get(token)
  end

  test "create returns an error with bad email" do
    credentials = %{email: "nonexistant", password: "bogus"}

    assert {:error, :invalid} = Session.create(credentials.email, credentials.password)
  end

  test "create returns an error with bad password" do
    credentials = %{email: "x@y.com", password: "swordfish"}
    {:ok, _user} = Auth.register_user(credentials)

    assert {:error, :invalid} =
      Session.create("x@y.com", "bogus")
  end

  test "get returns an error with unknown token" do
    assert {:error, :not_found} = Session.get("fake")
  end

  test "delete returns an error with unknown token" do
    assert {:error, :not_found} = Session.delete("fake")
  end

  test "expired sessions aren't found even when they haven't been purged" do
    credentials = %{email: "x@y.com", password: "swordfish"}
    {:ok, _user} = Auth.register_user(credentials)
    expired = Timex.subtract(Timex.now, Timex.Duration.from_seconds(10))
    assert {:ok, session} = Session.create(credentials.email,
                                           credentials.password,
                                           expired)

    assert {:error, :expired} = Session.get(session.token)
  end

  test "expired sessions are purged" do
    credentials = %{email: "x@y.com", password: "swordfish"}
    {:ok, _user} = Auth.register_user(credentials)

    assert {:ok, session} = Session.create(credentials.email,
                                           credentials.password,
                                           Timex.now)

    Session.cleanup_expired_sessions!

    assert {:error, :not_found} = Session.get(session.token)
  end
end
