defmodule RetroBoardWeb.GuestLoginLive do
  use RetroBoardWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Let us know who you are.
      </.header>
      <.simple_form
        :let={f}
        id="guest_form"
        for={:guest}
        action={~p"/guests/log_in"}
        as={:guest}
        phx-update="ignore"
      >
        <.input field={{f, :user_name}} type="text" label="Guest Name" required />
        <:actions>
          <.button phx-disable-with="Sigining in..." class="w-full">
            Sign in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user_name = live_flash(socket.assigns.flash, :user_name)
    {:ok, assign(socket, user_name: user_name), temporary_assigns: [user_name: nil]}
  end
end
