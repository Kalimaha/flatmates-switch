defmodule Switch.Cache do
  defmacro __using__(_) do
    quote do
      use GenServer

      def start_link(opts \\ []) do
        GenServer.start_link(__MODULE__, [{:ets_table_name, opts[:cache_name]}], opts)
      end

      def lookup(key) do
        GenServer.call(__MODULE__, {:lookup, key})
      end

      def insert(key, value) do
        GenServer.call(__MODULE__, {:insert, key, value})
      end

      def delete(key) do
        GenServer.call(__MODULE__, {:delete, key})
      end

      def handle_call({:lookup, key}, _from, state) do
        %{ets_table_name: ets_table_name} = state
        cache_value = :ets.lookup(ets_table_name, key)
        case cache_value do
          [] -> {:reply, nil, state}
          _ -> {:reply, cache_value[key], state}
        end
      end

      def handle_call({:insert, key, value}, _from, state) do
        %{ets_table_name: ets_table_name} = state
        true = :ets.insert(ets_table_name, {key, value})
        {:reply, value, state}
      end

      def handle_call({:delete, key}, _from, state) do
        %{ets_table_name: ets_table_name} = state
        :ets.delete(ets_table_name, key)
        {:reply, :ok, state}
      end

      def init(args) do
        [{:ets_table_name, ets_table_name}] = args

        :ets.new(ets_table_name, [:set, :protected, :named_table])

        {:ok, %{ets_table_name: ets_table_name}}
      end
    end
  end
end
