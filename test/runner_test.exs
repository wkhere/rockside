defmodule Rockside.RunnerTest do
  use ExUnit.Case

  test "Rockside.run starts the tcp listener" do
    port = 5000 + :random.uniform(100)
    {:ok, srv} = Rockside.run(Rockside.Sanity, port)
    {:ok, cli} = :gen_tcp.connect(:localhost, port, [])
    :gen_tcp.shutdown(cli, :read_write)
    Process.exit(srv, :terminate)
  end
end
