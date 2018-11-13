defmodule SwitchWeb.PagesControllerTest do
  use SwitchWeb.ConnCase

  test "renders index.html", %{conn: conn} do
    response = conn |> get(pages_path(conn, :index)) |> html_response(200)

    assert response =~ "<script src=\"/js/main.js\"></script>"
  end
end
