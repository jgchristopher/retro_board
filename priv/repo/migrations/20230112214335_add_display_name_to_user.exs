defmodule RetroBoard.Repo.Migrations.AddDisplayNameToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :display_name, :string, null: false
    end
  end
end
