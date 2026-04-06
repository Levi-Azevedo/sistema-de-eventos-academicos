defmodule SistemaEventos.Repo.Migrations.AddProfileFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table (:users) do
     add :nome, :string
     add :matricula, :string 
     end 
  end
end
