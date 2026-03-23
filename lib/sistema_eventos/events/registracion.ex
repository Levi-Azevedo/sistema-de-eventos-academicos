defmodule SistemaEventos.Events.Registracion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "registracions" do
    field :user_id, :id
    field :event_id, :id

  
    timestamps(type:  :utc_datetime)
  end

  @doc false 
  def changeset(registracion, attrs) do
    registracion
    |> cast(attrs, [:user_id, :event_id])
    |> validate_required([:user_id, :event_id])
    |> unique_constraint([:user_id, :event_id], name:  :registracion_user_id_event_id_index)    #trava inscricao unica
  end
end