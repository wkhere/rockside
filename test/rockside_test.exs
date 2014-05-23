defmodule Rockside.Doc.Test do
  use ExUnit.Case
  import Rockside.Doc

  test "content nested between tags" do
    assert body("foo") |> flush  == "<body>foo</body>"
  end

  test "nested tags" do
    assert html(body) |> flush =~ "<html><body></body></html>"
  end

  test "html has doctype" do
    assert html([]) |> flush =~ "<!DOCTYPE html>"
  end

  test "generic tag without attributes" do
    assert tag(:foo, "content") |> flush == ~s[<foo>content</foo>]
  end

  test "generic tag attributes" do
    assert tag(:foo, [class: "bar"], nil) |> flush ==
      ~s[<foo class="bar"></foo>]
  end

  test "generic tag attributes plus content" do
    assert tag(:foo, [class: "bar"], "quux") |> flush ==
      ~s[<foo class="bar">quux</foo>]
  end

  test "generic tag1 without attributes" do
    assert tag1(:foo) |> flush == ~s[<foo />]
  end

  test "generic tag1 with attributes" do
    assert tag1(:foo, [class: "bar"]) |> flush == ~s[<foo class="bar" />]
  end

  test "meta tag", do: assert meta([]) |> flush == ~s[<meta />]

  test "html tag attributes" do
    assert html([foo: "bar"], nil) |> flush =~
      ~s[<html foo="bar"></html>]
  end
end

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
    assert conn.resp_body == 
      ~s[<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html" /><title>foo</title></head><body>foo</body></html>]
  end
end

