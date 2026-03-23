defmodule SistemaEventos.Repo.Migrations.CreateRegistrations do
  use Ecto.Migration

  def change do
    create table(:registracions) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :event_id, references(:events, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:registracions, [:user_id, :event_id])
  end
end
