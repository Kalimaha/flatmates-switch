defmodule SwitchWeb.CacheHelper do
  alias Switch.UsersCache

  def clear_cache(user: user) do
    case user.id do
      nil -> nil
      _ -> user.id |> atomize() |> UsersCache.delete()
    end

    case {user.external_id, user.source} do
      {nil, nil} -> nil
      {_, _} -> "#{user.external_id}_#{user.source}" |> atomize() |> UsersCache.delete()
    end
  end

  def atomize(id) do
    cond do
      Kernel.is_bitstring(id) -> String.to_atom(id)
      Kernel.is_integer(id) -> String.to_atom(Integer.to_string(id))
    end
  end
end
