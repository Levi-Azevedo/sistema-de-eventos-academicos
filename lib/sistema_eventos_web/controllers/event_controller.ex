defmodule SistemaEventosWeb.EventController do
  use SistemaEventosWeb, :controller
  
  alias SistemaEventos.Events
  alias SistemaEventos.Events.Event

  def index(conn, _params) do
    events = Events.list_events()
    render(conn, :index, events: events)
  end

  def new(conn, _params) do
    changeset = Events.change_event(%Event{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    case Events.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: ~p"/events/#{event}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    render(conn, :show, event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    changeset = Events.change_event(event)
    render(conn, :edit, event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Events.get_event!(id)

    case Events.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: ~p"/events/#{event}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    {:ok, _event} = Events.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: ~p"/events")
  end

  def register(conn, %{"id" => event_id}) do
  user = conn.assigns.current_user

  case Events.register_user(event_id, user.id) do
    {:ok, _registracion} ->
      conn
      |> put_flash(:info, "Inscricao realizada com sucesso!!!!")
      |> redirect(to: ~p"/events/#{event_id}")
      
    {:error, :vagas_esgotadas} ->
     conn 
     |>put_flash(:info, "As vagas para esse evento estao esgotadas, mto paia ne ")
     |> redirect(to: ~p"/events/#{event_id}")
    
    {:error, :_changeset} ->
     conn
     |>put_flash(:error, "voce ja ta inscrito, lerdao, se ligue")
     |> redirect(to: ~p"/events/#{event_id}")
    end
  end
end
