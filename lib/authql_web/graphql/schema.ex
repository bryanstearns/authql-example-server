defmodule AuthqlWeb.GraphQL.Schema do
  use Absinthe.Schema
  import_types AuthqlWeb.GraphQL.Types

  query do
    field :users, list_of(:user) do
      resolve &AuthqlWeb.GraphQL.UserResolver.all/2
    end
  end
end
