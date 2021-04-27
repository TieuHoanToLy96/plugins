# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api,
  ecto_repos: [Api.Repo]

# Configures the endpoint
config :api, ApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7u4sea4G7OnlA28w3q6AgixJrEEKwVzIuyEnro7iUy0jvxrDOHWYsWV4fvoBMW/C",
  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Api.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :api, Api.Guardian,
  issuer: "api",
  secret_key: "djKR/dka+Njg4u4PrT1/aFm7RnIB37eI5Is8ERme+borJIVAiBqYnXAj/0hlMfRm"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
