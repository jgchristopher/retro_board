defmodule RetroBoard.Repo.Migrations.AddUserToBoard do
  use Ecto.Migration

  def change do
    alter table(:boards) do
      add :user_id, references(:users, on_delete: :nothing), null: false
    end

    create index(:boards, [:user_id])
  end
end
