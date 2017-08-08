# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Authql.Repo.insert!(%Authql.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Authql.Auth
alias Authql.Auth.User

{:ok, %User{}} = Auth.register_user(%{email: "bryanstearns@gmail.com", password: "swordfish"})
{:ok, %User{}} = Auth.register_user(%{email: "test@example.com", password: "testtest"})
