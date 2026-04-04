defmodule SistemaEventosWeb.EventController do
  use SistemaEventosWeb, :controller
  
  alias SistemaEventos.Events
  alias SistemaEventos.Events.Event

  plug :check_event_owner when action in [:edit, :update, :delete]
  plug :ensure_palestrante_ou_admin when action in [:new, :create]
  plug :ensure_admin_ou_aluno when action in [:register]

  def index(conn, _params) do
    events = Events.list_events()
    render(conn, :index, events: events)
  end

  def new(conn, _params) do
    changeset = Events.change_event(%Event{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    event_params = Map.put(event_params, "user_id", conn.assigns.current_user.id)
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

  defp check_event_owner(conn, _opts) do 
    event_id = conn.params["id"]
    event = Events.get_event!(event_id)
    user = conn.assigns.current_user

    if event.user_id == user.id or user.role == "admin" do
      conn
    else 
      conn
      |> put_flash(:error, "Voce nao é o dono do evento pai, se mande va")
      |> redirect(to: ~p"/events")
      |> halt()
    end
  end

  defp ensure_palestrante_ou_admin(conn, _opts) do
    user = conn.assigns.current_user
    if user.role in ["palestrante", "admin"] do
      conn
    else
      conn
      |> put_flash(:error, "somente palestrantes podem cirar eventos, irmao")
      |> redirect(to: ~p"/events")
      |> halt()
    end
  end

  defp ensure_admin_ou_aluno(conn, _opts) do
    user = conn.assigns.current_user
    if user.role in ["aluno", "admin"] do
      conn
    else
      conn 
      |> put_flash(:error, "somente alunos podem se inscrever nas palestras???")
      |> redirect(to: ~p"/events")
      |> halt()
    end
  end

end
