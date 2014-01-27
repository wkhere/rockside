defmodule Rockside do
  def run_sanity() do
    Plug.Adapters.Cowboy.http Rockside.Sanity, []
  end
end

defmodule Rockside.Sanity do
  import Plug.Connection

  def call(conn, []) do
    #:timer.sleep 1000
    conn = conn
      |> put_resp_content_type("text/plain")
      |> send_resp(200, "Pong")
    {:ok, conn}
  end
end
