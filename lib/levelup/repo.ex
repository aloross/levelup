defmodule Levelup.Repo do
  use Ecto.Repo,
    otp_app: :levelup,
    adapter: Ecto.Adapters.Postgres
end
