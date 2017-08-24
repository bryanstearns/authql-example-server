# defmodule ExampleWeb.GraphQL.SessionResolver do
#   require Logger
#
#   def login(args, _info) do
#     case Example.Auth.create_session(args) do
#       {:error, _reason} -> {:error, "Invalid email or password"}
#       ok_session -> ok_session
#     end
#   end
#
#   def logout(args, _info) do
#     case Example.Auth.delete_session(args) do
#       {:error, _reason} -> {:error, "Unknown Token"}
#       ok_session -> ok_session
#     end
#   end
# end
