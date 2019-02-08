defmodule Switch.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Switch.Repo, []),
      supervisor(SwitchWeb.Endpoint, []),
      supervisor(Switch.CacheSupervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Switch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    SwitchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
