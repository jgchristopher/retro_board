defmodule RetroBoard.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset
  alias RetroBoard.Cards.Card
  alias RetroBoard.Accounts.User

  schema "boards" do
    field :title, :string
    has_many :start_cards, Card, where: [type: "start"], preload_order: [asc: :id]
    has_many :stop_cards, Card, where: [type: "stop"], preload_order: [asc: :id]
    has_many :continue_cards, Card, where: [type: "continue"], preload_order: [asc: :id]

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title])
    |> assoc_constraint(:user)
  end
end
