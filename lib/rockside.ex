defmodule Rockside do
  def run_sanity() do
    Plug.Adapters.Cowboy.http Rockside.Sanity, []
  end
end
