defmodule Rockside do
  def run(module) do
    {:ok, _} = Plug.Adapters.Cowboy.http(module, [])
  end
end
