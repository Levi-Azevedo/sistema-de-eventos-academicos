defmodule SistemaEventosWeb.EventLive.Show do
  use SistemaEventosWeb, :live_view
  alias SistemaEventos.Events
  alias SistemaEventos.Chat
  alias SistemaEventos.Chat.Message

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    IO.inspect("chat_event:#{id}", label:  "LIVEView se inscreveu")
    if connected?(socket), do: Chat.subscribe(id)

    event = Events.get_event!(id)
    messages = Chat.list_messages(id)

    user = if socket.assigns[:current_scope], do: socket.assigns.current_scope.user, else: nil

      is_registered? =
        if user do 
          Events.is_user_registered?(event.id, user.id)
        else 
          false
        end 

        is_owner = if user, do: user.id == event.user_id, else: false

        has_chat_permission = 
          if user do
            is_owner or Events.is_user_registered?(event.id, user.id)
          else 
            false
          end

    socket =
      socket
      |> assign(:event, event)
      |> assign(:current_user, user)
      |> assign(:is_registered?, has_chat_permission)
      |> assign(:message_form, to_form(Chat.change_message(%SistemaEventos.Chat.Message{})))
      |> stream(:messages, messages)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"message" => params}, socket) do
    changeset = 
      %SistemaEventos.Chat.Message{}
      |> Chat.change_message(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :message_form, to_form(changeset))}
  end

  @impl true
  def handle_event("send_message", %{"message" => message_params}, socket) do
    user = socket.assigns.current_user
    event = socket.assigns.event

    params = 
      message_params 
      |> Map.put("user_id", user.id) 
      |> Map.put("event_id", event.id)

    case Chat.create_message(params) do
      {:ok, _message} ->
       
        {:noreply, assign(socket, :message_form, to_form(Chat.change_message(%Message{})))}

      {:error, changeset} ->
        {:noreply, assign(socket, :message_form, to_form(changeset))}
    end
  end

  @impl true
  def handle_info({:new_message, message}, socket) do
    {:noreply, stream_insert(socket, :messages, message)}
  end
end