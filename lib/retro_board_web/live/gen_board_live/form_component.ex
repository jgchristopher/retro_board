defmodule RetroBoardWeb.BoardLive.FormComponent do
  use RetroBoardWeb, :live_component

  alias RetroBoard.Boards

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage board records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="board-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :title}} type="text" label="Title" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Board</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{board: board} = assigns, socket) do
    changeset = Boards.change_board(board)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"board" => board_params}, socket) do
    changeset =
      socket.assigns.board
      |> Boards.change_board(board_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"board" => board_params}, socket) do
    save_board(socket, socket.assigns.action, board_params)
  end

  defp save_board(socket, :edit, board_params) do
    case Boards.update_board(socket.assigns.board, board_params) do
      {:ok, _board} ->
        {:noreply,
         socket
         |> put_flash(:info, "Board updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_board(socket, :new, board_params) do
    case Boards.create_board(board_params) do
      {:ok, _board} ->
        {:noreply,
         socket
         |> put_flash(:info, "Board created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
