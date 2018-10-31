defmodule SwitchWeb.FeatureToggleController do
  use SwitchWeb, :controller

  alias SwitchWeb.FeatureToggleRepository

  def index(conn, _params) do
    feature_toggles = FeatureToggleRepository.list

    conn
    |> put_status(200)
    |> json(feature_toggles)
  end
end
