defmodule AuthqlWeb.PageController do
  use AuthqlWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
