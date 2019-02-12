defmodule SwitchWeb.UsersCachedRepository do
  alias Switch.UsersCache
  alias SwitchWeb.UsersRepository

  def get(id) do
    cached_user = atomize(id) |> UsersCache.lookup()

    case cached_user do
      nil -> cache_and_return(id)
      _ -> cached_user
    end
  end

  def get(id, source) do
    cached_user = key(id, source) |> UsersCache.lookup()

    case cached_user do
      nil -> cache_and_return(id, source)
      _ -> cached_user
    end
  end

  defp atomize(id) do
    cond do
      Kernel.is_bitstring(id) -> String.to_atom(id)
      Kernel.is_integer(id) -> String.to_atom(Integer.to_string(id))
    end
  end

  defp key(id, source) do
    String.to_atom("#{id}_#{source}")
  end

  defp cache_and_return(id) do
    db_user = UsersRepository.get(id)

    case db_user do
      nil ->
        nil

      _ ->
        spawn(fn -> atomize(db_user.id) |> UsersCache.insert(db_user) end)
        db_user
    end
  end

  defp cache_and_return(id, source) do
    db_user = UsersRepository.find_by_external_id_and_source(id, source)

    case db_user do
      nil ->
        nil

      _ ->
        spawn(fn -> key(id, source) |> UsersCache.insert(db_user) end)
        db_user
    end
  end
end
