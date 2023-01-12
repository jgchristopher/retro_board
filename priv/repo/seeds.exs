# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RetroBoard.Repo.insert!(%RetroBoard.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias RetroBoard.Repo
alias RetroBoard.Boards.Board
alias RetroBoard.Cards.Card
alias RetroBoard.Accounts

{:ok, user} =
  Accounts.register_user(%{
    "display_name" => "jgchristopher",
    "email" => "john@jdotc.xyz",
    "password" => "123456123456"
  })

board =
  Repo.insert!(%Board{
    title: "Board 1",
    user_id: user.id
  })

cards = [
  %Card{
    body: "Keep being awesome!",
    type: "continue",
    user: "Anonymous",
    board_id: board.id
  },
  %Card{
    body: "Keep being awesome!",
    type: "start",
    user: "Anonymous",
    board_id: board.id
  },
  %Card{
    body: "Keep being awesome!",
    type: "stop",
    user: "Anonymous",
    board_id: board.id
  },
  %Card{
    body:
      "What if we have a bunch of text that someone put in because they had a long topic to disuss?",
    type: "continue",
    user: "Anonymous",
    board_id: board.id
  },
  %Card{
    body:
      "What if we have a bunch of text that someone put in because they had a long topic to disuss?",
    type: "continue",
    user: "Anonymous",
    board_id: board.id
  },
  %Card{
    body:
      "What if we have a bunch of text that someone put in because they had a long topic to disuss?",
    type: "continue",
    user: "Anonymous",
    board_id: board.id
  }
]

Enum.each(cards, fn card ->
  Repo.insert(card)
end)
