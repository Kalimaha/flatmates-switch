defmodule SwitchWeb.Router do
  use SwitchWeb, :router
  alias SwitchWeb.APIVersion

  pipeline :v1 do
    plug(CORSPlug, origin: "*")
    plug(:accepts, ["json"])
    plug(APIVersion, version: :v1)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/api/v1", SwitchWeb do
    pipe_through(:v1)

    resources("/users", UsersController)

    resources("/feature-toggles", FeatureTogglesController) do
      resources("/rules", FeatureToggleRulesController)
    end

    get("/switches", SwitchesController, :get_or_create)
  end

  scope "/", SwitchWeb do
    pipe_through(:browser)

    get("/", PagesController, :index)
  end
end
