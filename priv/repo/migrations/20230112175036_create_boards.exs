defmodule RetroBoard.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :title, :string

      timestamps()
    end
  end
end
