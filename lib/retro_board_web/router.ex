defmodule RetroBoardWeb.Router do
  use RetroBoardWeb, :router

  import RetroBoardWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RetroBoardWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RetroBoardWeb do
    pipe_through :browser

    get "/", PageController, :home

    # live "/boards", BoardLive.Index, :index
    # live "/boards/new", BoardLive.Index, :new
    # live "/boards/:id/edit", BoardLive.Index, :edit
    #
    # live "/boards/:id", BoardLive.Show, :show
    # live "/boards/:id/show/edit", BoardLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", RetroBoardWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:retro_board, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RetroBoardWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", RetroBoardWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{RetroBoardWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/guests/log_in", GuestLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
    post "/guests/log_in", UserSessionController, :create
  end

  # require_guest_or_authenticated_user
  scope "/", RetroBoardWeb do
    pipe_through [:browser, :require_guest_or_authenticated_user]

    live_session :require_guest_or_authenticated_user,
      on_mount: [{RetroBoardWeb.UserAuth, :ensure_user_or_guest}] do
      live "/myboards/:id", BoardShowLive
    end
  end

  scope "/", RetroBoardWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{RetroBoardWeb.UserAuth, :ensure_authenticated}] do
      live "/myboards", BoardLive
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", RetroBoardWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{RetroBoardWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
