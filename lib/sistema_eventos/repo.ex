defmodule SistemaEventos.Repo do
  use Ecto.Repo,
    otp_app: :sistema_eventos,
    adapter: Ecto.Adapters.Postgres
end
