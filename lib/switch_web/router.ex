defmodule SwitchWeb.Router do
  use SwitchWeb, :router

  pipeline :api do
    plug(CORSPlug, origin: "*")
    plug(:accepts, ["json"])
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/api", SwitchWeb do
    pipe_through(:api)

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
