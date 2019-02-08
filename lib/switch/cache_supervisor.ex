defmodule Switch.CacheSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Switch.UsersCache, [[cache_name: :users_cache]]),
      worker(Switch.SwitchesCache, [[cache_name: :switches_cache]]),
      worker(Switch.FeatureTogglesCache, [[cache_name: :feature_toggles_cache]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
