defmodule ExampleWeb.Router do
  use ExampleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug Authql.WebContext
  end

  scope "/api" do
    pipe_through :api
    forward "/", Absinthe.Plug, schema: ExampleWeb.GraphQL.Schema
  end
  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: ExampleWeb.GraphQL.Schema

  scope "/", ExampleWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

end
