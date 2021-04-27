defmodule Api.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      Api.Repo,
      ApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Api.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
