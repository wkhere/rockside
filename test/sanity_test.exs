defmodule Rockside.Plug.Sanity.Test do
  use ExUnit.Case
  use Plug.Test
  import Rockside.Sanity
  @opts init([])

  test "sanity response" do
    conn = conn(:get, "/") |> call @opts
    assert conn.state == :sent
    assert conn.status == 200
    [type] = conn |> get_resp_header("content-type")
    assert type == "text/html; charset=utf-8"
    assert conn.resp_body |> String.replace("\n", "") ==
      ~s[<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html" /><title>foo</title></head><body>foo</body></html>]
  end
end
