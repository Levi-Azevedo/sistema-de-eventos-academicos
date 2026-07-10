defmodule SistemaEventos.Chat do
    import Ecto.Query, warn: false
    alias SistemaEventos.Repo
    alias SistemaEventos.Chat.Message

    def list_messages(event_id) do
            from(m in Message,
                where: m.event_id == ^event_id,
                preload: [:user],
                order_by: [asc: :inserted_at]
            )
            |> Repo.all()
    end

    def create_message(attrs \\ %{}) do
        %Message{}
        |> Message.changeset(attrs)
        |> Repo.insert()
        |> broadcast_message()
    end

    def change_message(%Message{} = message, attrs \\ %{}) do
        Message.changeset(message, attrs)
    end

    def subscribe(event_id) do
        Phoenix.PubSub.subscribe(SistemaEventos.PubSub, "chat_event:#{event_id}")
    end

    defp broadcast_message({:ok, message} = result) do
        message = Repo.preload(message, :user)
        
        Phoenix.PubSub.broadcast(
        SistemaEventos.PubSub,
        "chat_event:#{message.event_id}",
        {:new_message, message}
        )
        result
    end

    defp broadcast_message(result), do: result
    

end