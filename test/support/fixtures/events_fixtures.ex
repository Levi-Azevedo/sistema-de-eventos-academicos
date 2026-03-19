defmodule SistemaEventos.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SistemaEventos.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        date: ~U[2026-03-18 21:20:00Z],
        description: "some description",
        location: "some location",
        title: "some title",
        total_slots: 42
      })
      |> SistemaEventos.Events.create_event()

    event
  end
end
