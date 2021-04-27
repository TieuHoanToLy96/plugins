use Mix.Config

config :api, ApiWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/brunch/bin/brunch",
      "watch",
      "--stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# config :api, ApiWeb.Endpoint,
#   live_reload: [
#     patterns: [
#       ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
#       ~r{priv/gettext/.*(po)$},
#       ~r{lib/api_web/views/.*(ex)$},
#       ~r{lib/api_web/templates/.*(eex)$}
#     ]
#   ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :api, Api.Repo,
  username: System.get_env("PG_USERNAME") || "postgres",
  password: System.get_env("PG_PASSWORD") || "postgres",
  database: System.get_env("PG_DB") || "api_dev",
  hostname: System.get_env("PG_HOST") || "api-db",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
