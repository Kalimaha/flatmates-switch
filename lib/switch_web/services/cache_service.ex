defmodule SwitchWeb.CacheService do
  @cache_name :switches_cache

  def initialize do
    :ets.new(@cache_name, [:set, :protected, :named_table])
  end

  def insert(key, value) do
    :ets.insert(@cache_name, {key, value})
  end

  def lookup(key) do
    cache_value = :ets.lookup(@cache_name, key)

    case cache_value do
      [] -> {:ok, nil}
      _ -> {:ok, cache_value[key]}
    end
  end

  def delete(key) do
    :ets.delete(@cache_name, key)
  end
end
