defmodule ApiWeb.Router do
  use ApiWeb, :router
  alias ApiWeb.Plug.{
    AccountPlug,
    TokenPlug
  }

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :account do
    plug AccountPlug
  end

  pipeline :token do
    plug TokenPlug
  end

  scope "/", ApiWeb do
    pipe_through([:browser, :token, :account])

    scope "/sites" do
      get "/all", SiteController, :all_site
      post "/create", SiteController, :create_site
      post "/update", SiteController, :update_site
    end
    
    get("/", PageController, :index)
  end

  scope "/oauth2", ApiWeb do
    pipe_through(:api)

    post("/pancakeid/login", AuthController, :oauth2_login)
  end
end
