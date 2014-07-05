defmodule Rockside do
  def run(module) do
    Plug.Adapters.Cowboy.http(module, [])
  end
end
