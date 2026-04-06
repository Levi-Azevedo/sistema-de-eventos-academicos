defmodule SistemaEventos.Chat.Message do
    use Ecto.Schema
    import Ecto.Changeset

    schema "messages" do 
        field :content, :string
        belongs_to :user, SistemaEventos.Accounts.User
        belongs_to :event, SistemaEventos.Events.Event

        timestamps(type: :utc_datetime)
    end

    def changeset(message, attrs) do
        message
        |> cast(attrs, [:content, :user_id, :event_id])
        |> validate_required([:content, :user_id, :event_id])
    end
end