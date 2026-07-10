defmodule SistemaEventos.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do 
      add :content, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :event_id, references(:events, on_delete: :delete_all), null: false

      timestamps(type:  :utc_datetime)
    end
    create index(:messages, [:user_id])
    create index(:messages, [:event_id])
  end
end
