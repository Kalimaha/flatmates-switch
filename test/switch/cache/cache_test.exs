defmodule Switch.CacheTest do
  use ExUnit.Case, async: true

  defmodule TestCache do
    use Switch.Cache
  end

  setup do
    server = start_supervised!({Switch.CacheTest.TestCache, cache_name: :spam})
    %{server: server}
  end

  test "insert value in the cache", %{server: server} do
    assert "Spam & Eggs" == GenServer.call(server, {:insert, :spam, "Spam & Eggs"})
  end

  test "lookup value in the cache", %{server: server} do
    GenServer.call(server, {:insert, :spam, "Spam & Eggs"})

    assert "Spam & Eggs" == GenServer.call(server, {:lookup, :spam})
  end

  test "delete value from the cache", %{server: server} do
    GenServer.call(server, {:insert, :spam, "Spam & Eggs"})
    GenServer.call(server, {:delete, :spam})

    assert nil == GenServer.call(server, {:lookup, :spam})
  end

  test "update value in the cache", %{server: server} do
    GenServer.call(server, {:insert, :spam, "Spam & Eggs"})
    GenServer.call(server, {:insert, :spam, "Spam, bacon, sausage and Spam"})

    assert "Spam, bacon, sausage and Spam" == GenServer.call(server, {:lookup, :spam})
  end
end
