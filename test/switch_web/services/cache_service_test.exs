defmodule SwitchWeb.CacheServiceTest do
  use Switch.DataCase

  alias SwitchWeb.CacheService

  @value_1 "eggs"
  @value_2 "bacon"

  test "initialize cache" do
    CacheService.initialize()

    assert CacheService.lookup(:this_is_the_key) == {:ok, nil}
  end

  test "value lookup" do
    CacheService.initialize()
    CacheService.insert(:this_is_the_key, %{spam: @value_1})
    CacheService.insert(:this_is_the_key, %{spam: @value_2})

    {:ok, value} = CacheService.lookup(:this_is_the_key)
    assert value[:spam] == @value_2
  end

  test "access a key from a non-existent cache" do
    try do
      CacheService.insert(:this_is_the_key, %{spam: @value_1})
    rescue
      e in ArgumentError -> assert e == %ArgumentError{message: "argument error"}
    end
  end

  test "deletes a key from the cache" do
    CacheService.initialize()
    CacheService.insert(:this_is_the_key, %{spam: @value_1})
    CacheService.delete(:this_is_the_key)

    assert CacheService.lookup(:this_is_the_key) == {:ok, nil}
  end
end
