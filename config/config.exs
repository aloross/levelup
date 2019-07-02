# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :levelup,
  ecto_repos: [Levelup.Repo]

# Configures the endpoint
config :levelup, LevelupWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HD19Dy5jRaTHgObfrGNVNdYQuKt8jDXnN22mrlt6/NC/fE7eQbHVwAsCnbWkXEy8",
  render_errors: [view: LevelupWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Levelup.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :levelup, Levelup.Accounts.Guardian,
  issuer: "levelup",
  secret_key: "YiAAE+h8zUSnRPEA4EgdFRZChu7FJo6loyuIIgWtqop/9H+MoQZLZiIbr9+WlKro"

config :triplex, repo: Levelup.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
