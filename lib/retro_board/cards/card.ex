defmodule RetroBoard.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :body, :string
    field :type, :string
    field :user, :string
    belongs_to :board, RetroBoard.Boards.Board

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:body, :type, :user, :board_id])
    |> validate_required([:body, :type, :user, :board_id])
  end
end
