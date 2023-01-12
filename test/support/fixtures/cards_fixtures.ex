defmodule RetroBoard.CardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RetroBoard.Cards` context.
  """

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    {:ok, card} =
      attrs
      |> Enum.into(%{
        body: "some body",
        type: "some type",
        user: "some user"
      })
      |> RetroBoard.Cards.create_card()

    card
  end
end
