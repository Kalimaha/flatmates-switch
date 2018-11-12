defmodule SwitchWeb.PageControllerTest do
  use SwitchWeb.ConnCase

  test "renders index.html", %{conn: conn} do
    response = conn |> get(page_path(conn, :index)) |> html_response(200)

    assert response =~ "<script src=\"/js/app.js\"></script>"
  end
end
