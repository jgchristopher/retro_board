defmodule RetroBoard.Repo do
  use Ecto.Repo,
    otp_app: :retro_board,
    adapter: Ecto.Adapters.Postgres
end
