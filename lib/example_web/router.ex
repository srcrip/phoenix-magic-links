defmodule ExampleWeb.Router do
  use ExampleWeb, :router

  import ExampleWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ExampleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExampleWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExampleWeb do
  #   pipe_through :api
  # end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:example, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", ExampleWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{ExampleWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/login", UserLoginLive, :new
    end

    post "/login", UserSessionController, :send_magic_link

    get "/login/email/token/:token", UserSessionController, :login_with_token
  end

  scope "/", ExampleWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{ExampleWeb.UserAuth, :ensure_authenticated}] do
      live "/account", UserSettingsLive, :edit
      live "/account/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", ExampleWeb do
    pipe_through [:browser]

    delete "/logout", UserSessionController, :delete
  end
end
