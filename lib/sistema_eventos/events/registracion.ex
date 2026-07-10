defmodule SistemaEventos.Events.Registracion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "registracions" do
    belongs_to :user, SistemaEventos.Accounts.User
    belongs_to :event, SistemaEventos.Events.Event

  
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