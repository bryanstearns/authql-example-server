# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Example.Repo.insert!(%Example.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Authql.User

if Mix.env == :dev do
  {:ok, %User{}} = Authql.register_user(%{email: "bryanstearns@gmail.com", password: "swordfish"})
  {:ok, %User{}} = Authql.register_user(%{email: "test@example.com", password: "testtest"})
end
