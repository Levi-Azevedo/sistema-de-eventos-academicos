defmodule SistemaEventos.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias SistemaEventos.Repo

  alias SistemaEventos.Events.Event

  alias SistemaEventos.Events.Registracion

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def is_user_registered?(event_id, user_id)do
    query = 
      from r in Registracion,
      where: r.event_id == ^event_id and r.user_id == ^user_id

    Repo.exists?(query)
  end


  def register_user(event_id,user_id) do #registrador de usuario em um evento, desde q haja vagas
    event = get_event!(event_id)
    
    contagem_atual =  Repo.aggregate(
      from(r in Registracion, where: r.event_id == ^event_id),
      :count, :id
    )

    if contagem_atual < event.total_slots do
      %Registracion{}
      |> Registracion.changeset(%{event_id: event_id, user_id: user_id})
      |> Repo.insert()
    else 
      {:error, :vagas_esgotadas}
    end
  end
end
