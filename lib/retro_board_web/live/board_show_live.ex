defmodule RetroBoardWeb.BoardShowLive do
  use RetroBoardWeb, :live_view
  require Logger

  alias RetroBoard.Boards
  alias RetroBoard.Cards.Card

  alias RetroBoardWeb.Presence

  @impl true
  def mount(_params, session, socket) do
    user_name = Map.get(session, "user_name")

    {:ok,
     socket
     |> assign(:user_name, user_name)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    board_topic = "board:#{id}:new_card"

    if connected?(socket) do
      RetroBoardWeb.Endpoint.subscribe(board_topic)

      Presence.track(
        self(),
        board_topic,
        socket.id,
        %{
          user_name: socket.assigns.user_name
        }
      )
    end

    {:noreply,
     socket
     |> assign(:assigns, socket.assigns)
     |> assign(:board, Boards.get_board!(id))
     |> assign(:board_topic, board_topic)
     |> assign(:users, [])}
  end

  @impl true
  def handle_info({:new_card, card, :type, type}, socket) do
    cards = Map.get(socket.assigns.board, String.to_existing_atom("#{type}_cards"))

    board =
      Map.put(socket.assigns.board, String.to_existing_atom("#{type}_cards"), cards ++ [card])

    {:noreply,
     socket
     |> assign(:board, board)}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    users =
      Presence.list(socket.assigns.board_topic)
      |> Enum.map(fn {_, data} ->
        data[:metas]
        |> List.first()
      end)

    {:noreply, socket |> assign(:users, users)}
  end
end
