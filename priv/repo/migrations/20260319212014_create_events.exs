defmodule SistemaEventos.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :description, :text
      add :date, :utc_datetime
      add :location, :string
      add :total_slots, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
