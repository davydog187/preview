defmodule Preview.Package.Store do
  use GenServer

  @callback get_versions(binary()) :: {:ok, [binary()]} | {:error, :not_found}
  @callback get_names() :: [binary()]

  defp impl(), do: Application.get_env(:preview, :package_store_impl)

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    :ets.new(__MODULE__, [:named_table, :public])
    {:ok, []}
  end

  def get_versions(key) do
    impl().get_versions(key)
  end

  def get_names() do
    impl().get_names()
  end

  def fill(new_entries) do
    :ets.insert(__MODULE__, new_entries)
  end
end
