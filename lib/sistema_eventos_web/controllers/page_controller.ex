defmodule SistemaEventosWeb.PageController do
  use SistemaEventosWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
