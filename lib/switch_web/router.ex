defmodule SwitchWeb.Router do
  use SwitchWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/api", SwitchWeb do
    pipe_through :api

    resources "/feature-toggles", FeatureToggleController
  end

  scope "/", SwitchWeb do
    pipe_through :browser

    get "/", PageController, :index
  end
end
