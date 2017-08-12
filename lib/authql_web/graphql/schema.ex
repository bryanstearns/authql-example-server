defmodule AuthqlWeb.GraphQL.Schema do
  use Absinthe.Schema
  import_types AuthqlWeb.GraphQL.Types

  query do
    field :users, list_of(:user) do
      resolve &AuthqlWeb.GraphQL.UserResolver.all/2
    end
  end

  mutation do
    @desc "Create a session and return a token"
    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &AuthqlWeb.GraphQL.SessionResolver.login/2
    end

    @desc "End a session and cancel the token"
    field :logout, type: :session do
      arg :token, non_null(:string)

      resolve &AuthqlWeb.GraphQL.SessionResolver.logout/2
    end
  end
end
