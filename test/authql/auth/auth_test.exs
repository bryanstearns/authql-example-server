defmodule Authql.AuthTest do
  use Authql.DataCase

  alias Authql.Auth
  alias Authql.Auth.User
  alias Authql.Auth.Session

  @valid_user_attrs %{email: "bob@example.com", password: "some password"}
  @update_user_attrs %{email: "ann@example.com", password: "updated password"}
  @invalid_user_attrs %{email: "bad", password: ""}

  @valid_session_attrs @valid_user_attrs
  @invalid_session_attrs @invalid_user_attrs

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_user_attrs)
      |> Auth.register_user()

    user
  end

  def session_fixture(attrs \\ %{}) do
    {:ok, session} =
      attrs
      |> Enum.into(@valid_session_attrs)
      |> Auth.create_session()

    session
  end

  describe "users" do
    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "register_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.register_user(@valid_user_attrs)
      assert user.email == "bob@example.com"
      assert "$2b$" <> _ = user.password_hash
    end

    test "register_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.register_user(@invalid_user_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      old_password_hash = user.password_hash
      assert {:ok, user} = Auth.update_user(user, @update_user_attrs)
      assert %User{} = user
      assert user.email == "ann@example.com"
      assert old_password_hash != user.password_hash
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_user_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end

  describe "sessions" do
    test "create_session/1 with valid data creates a session" do
      %User{} = user_fixture()
      assert {:ok, %Session{}} = Auth.create_session(@valid_session_attrs)
    end

    test "create_session/1 with invalid data returns error" do
      assert {:error, :invalid} = Auth.create_session(@invalid_session_attrs)
    end

    test "delete_session/1 deletes the session" do
      user_fixture()
      session = session_fixture()
      assert {:ok, session} = Auth.delete_session(%{token: session.token})
      assert {:error, :not_found} = Session.get(session.token)
    end

    test "get_session/1 with a valid token returns the session" do
      user_fixture()
      session = session_fixture()
      assert {:ok, ^session} = Auth.get_session(session.token)
    end

    test "get_session/1 with an invalid token returns an error" do
      assert {:error, :not_found} = Auth.get_session("bad_token")
    end

    test "token_valid?/1 with a valid token returns true" do
      user_fixture()
      session = session_fixture()
      assert Auth.token_valid?(session.token) == true
    end

    test "token_valid?/1 with an invalid token returns false" do
      assert Auth.token_valid?("bad_token") == false
    end
  end
end
