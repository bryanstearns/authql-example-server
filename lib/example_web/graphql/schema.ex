defmodule ExampleWeb.GraphQL.Schema do
  use Absinthe.Schema
  #import_types ExampleWeb.GraphQL.Types
  import_types Authql.GraphQLTypes

  query do
    field :users, list_of(:user) do
      arg :viewer, :string
      resolve &ExampleWeb.GraphQL.UserResolver.all/2
    end

    field :user, :user do
      arg :viewer, :string
      resolve &ExampleWeb.GraphQL.UserResolver.one/2
    end
  end

  mutation do
    import_fields :authql_mutations
  end
end
