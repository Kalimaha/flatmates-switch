defmodule Switch.CacheSupervisor do
  use Supervisor

  alias Switch.{UsersCache, SwitchesCache, FeatureTogglesCache}

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(UsersCache, [[name: UsersCache, cache_name: :users_cache]]),
      worker(SwitchesCache, [[name: SwitchesCache, cache_name: :switches_cache]]),
      worker(FeatureTogglesCache, [
        [name: FeatureTogglesCache, cache_name: :feature_toggles_cache]
      ])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
