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

  defp atomize(id) do
    cond do
      Kernel.is_bitstring(id) -> String.to_atom(id)
      Kernel.is_integer(id) -> String.to_atom(Integer.to_string(id))
    end
  end

  defp cache_and_return(id) do
    db_user = UsersRepository.get(id)

    case db_user do
      nil ->
        []

      _ ->
        spawn(fn -> atomize(db_user.id) |> UsersCache.insert(db_user) end)
        db_user
    end
  end
end
