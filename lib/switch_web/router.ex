defmodule SwitchWeb.Router do
  use SwitchWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SwitchWeb do
    pipe_through :api
    resources "/feature-toggles", FeatureToggleController
  end
end
