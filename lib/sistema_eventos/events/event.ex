defmodule SistemaEventos.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :title, :string
    field :description, :string
    field :date, :utc_datetime
    field :location, :string
    field :total_slots, :integer
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :description, :date, :location, :total_slots, :user_id])
    |> validate_required([:title, :description, :date, :location, :total_slots])
  end
end
