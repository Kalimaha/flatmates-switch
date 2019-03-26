defmodule SwitchWeb.UsersCachedRepository do
  alias Switch.UsersCache
  alias SwitchWeb.{UsersRepository, CacheHelper}

  def get(id: id) do
    cached_user = CacheHelper.atomize(id) |> UsersCache.lookup()

    case cached_user do
      nil -> cache_and_return(id)
      _ -> cached_user
    end
  end

  def get(external_id: external_id, user_source: user_source) do
    cached_user =
      cache_key(external_id, user_source) |> CacheHelper.atomize() |> UsersCache.lookup()

    case cached_user do
      nil -> cache_and_return(external_id, user_source)
      _ -> cached_user
    end
  end

  defp cache_key(external_id, user_source) do
    "#{external_id}_#{user_source}"
  end

  defp cache_and_return(id) do
    db_user = UsersRepository.get(id: id)

    case db_user do
      nil ->
        nil

      _ ->
        spawn(fn -> CacheHelper.atomize(db_user.id) |> UsersCache.insert(db_user) end)
        db_user
    end
  end

  defp cache_and_return(external_id, user_source) do
    db_user = UsersRepository.get(external_id: external_id, user_source: user_source)

    case db_user do
      nil ->
        nil

      _ ->
        spawn(fn ->
          cache_key(external_id, user_source)
          |> CacheHelper.atomize()
          |> UsersCache.insert(db_user)
        end)

        db_user
    end
  end
end
