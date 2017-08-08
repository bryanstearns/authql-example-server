defmodule Authql.AuthTest do
  use Authql.DataCase

  alias Authql.Auth

  describe "users" do
    alias Authql.Auth.User

    @valid_attrs %{email: "bob@example.com", password: "some password"}
    @update_attrs %{email: "ann@example.com", password: "updated password"}
    @invalid_attrs %{email: "bad", password: ""}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.register_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "register_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.register_user(@valid_attrs)
      assert user.email == "bob@example.com"
      assert "$2b$" <> _ = user.password_hash
    end

    test "register_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.register_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      old_password_hash = user.password_hash
      assert {:ok, user} = Auth.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "ann@example.com"
      assert old_password_hash != user.password_hash
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
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
end
