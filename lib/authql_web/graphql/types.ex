defmodule AuthqlWeb.GraphQL.Types do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :email, :string
  end

  object :session do
    field :user, :user
    field :token, :string
  end
end
