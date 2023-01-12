defmodule RetroBoardWeb.BoardColumnComponent do
  use RetroBoardWeb, :live_component
  alias RetroBoard.Cards
  require Logger

  @impl true
  def update(%{new_card: new_card, type: type} = assigns, socket) do
    new_card =
      new_card
      |> Map.put(:user, "Anonymous")
      |> Map.put(:type, type)

    changeset = Cards.change_card(new_card)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:valid, false)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"new_card" => new_card_params}, socket) do
    # For now just assign these here
    new_card_params =
      add_missing_params(new_card_params, socket.assigns.type, socket.assigns.board_id)

    changeset =
      socket.assigns.new_card
      |> Cards.change_card(new_card_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:valid, changeset.valid?)
     |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"new_card" => card_params}, socket) do
    # For now just assign these here
    card_params = add_missing_params(card_params, socket.assigns.type, socket.assigns.board_id)

    case Cards.create_card(card_params) do
      {:ok, card} ->
        # This is not efficient but the desired UX
        cards = socket.assigns.cards ++ [card]

        {:noreply,
         socket
         |> assign(:cards, cards)
         |> assign(:valid, false)}

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error(changeset)
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp button_valid(true), do: "bg-indigo-600 hover:bg-indigo-700"
  defp button_valid(false), do: "bg-zinc-600"

  defp add_missing_params(params, type, board_id) do
    params
    |> Map.put("user", "Anonymous")
    |> Map.put("type", type)
    |> Map.put("board_id", board_id)
  end
end
