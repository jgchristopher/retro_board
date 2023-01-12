defmodule RetroBoardWeb.BoardLive do
  use RetroBoardWeb, :live_view

  alias RetroBoard.Boards
  alias RetroBoard.Boards.Board
  alias RetroBoard.Accounts

  @impl true
  def mount(_params, session, socket) do
    new_board = %Board{}
    changeset = Boards.change_board(new_board)
    user = Accounts.get_user_by_session_token(Map.get(session, "user_token"))

    {:ok,
     socket
     |> assign(:boards, Boards.list_boards())
     |> assign(:page_title, "Our Boards")
     |> assign(:board, new_board)
     |> assign(:changeset, changeset)
     |> assign(:user, user)
     |> assign(:valid, false)}
  end

  @impl true
  def handle_event("validate", %{"board" => board_params}, socket) do
    board_params = board_params |> Map.put("user_id", socket.assigns.user.id)

    changeset =
      socket.assigns.board
      |> Boards.change_board(board_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:valid, changeset.valid?)
     |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"board" => board_params}, socket) do
    if socket.assigns.valid do
      board_params = board_params |> Map.put("user_id", socket.assigns.user.id)

      case Boards.create_board(board_params) do
        {:ok, board} ->
          list_of_boards = [board | socket.assigns.boards]

          {
            :noreply,
            socket
            |> assign(:boards, list_of_boards)
            |> assign(:valid, false)
            |> put_flash(:info, "Board created successfully")
          }

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, changeset: changeset)}
      end
    else
      {:noreply, socket}
    end
  end

  defp button_valid(true), do: "bg-indigo-600 hover:bg-indigo-700"
  defp button_valid(false), do: "bg-zinc-600"
end
