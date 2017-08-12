defmodule AuthqlWeb.Router do
  use AuthqlWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug AuthqlWeb.Context
  end

  scope "/api" do
    pipe_through :api
    forward "/", Absinthe.Plug, schema: AuthqlWeb.GraphQL.Schema
  end
  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: AuthqlWeb.GraphQL.Schema

  scope "/", AuthqlWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

end
