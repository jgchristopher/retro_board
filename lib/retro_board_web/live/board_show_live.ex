defmodule RetroBoardWeb.BoardShowLive do
  use RetroBoardWeb, :live_view
  require Logger

  alias RetroBoard.Boards
  alias RetroBoard.Cards.Card
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    if connected?(socket) do
      RetroBoardWeb.Endpoint.subscribe("board:#{id}:new_card")
    end

    {:noreply,
     socket
     |> assign(:board, Boards.get_board!(id))}
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
end
