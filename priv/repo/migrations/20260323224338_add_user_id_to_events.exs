defmodule SistemaEventos.Repo.Migrations.AddUserIdToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end