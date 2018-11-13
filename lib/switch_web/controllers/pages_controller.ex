defmodule SwitchWeb.PagesController do
  use SwitchWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
