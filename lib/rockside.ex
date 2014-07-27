defmodule Rockside do
  def run(module, port\\4000) do
    {:ok, _} = Plug.Adapters.Cowboy.http(module, [], port: port)
  end
end
