defmodule Rockside.Doc.Test do
  use ExUnit.Case
  import Kernel, except: [div: 2]
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

  test "html tag attributes" do
    assert html([foo: "bar"], nil) |> flush =~
      ~s[<html foo="bar"></html>]
  end

  test "meta tag", do: assert meta([]) |> flush == ~s[<meta />]

  test "link tag" do
    assert link([]) |> flush == "<link />"
    assert link([foo: "bar"]) |> flush == ~s[<link foo="bar" />]
  end

  test "css fun" do
    assert css("/a/w/e/some.css") |> flush ==
      ~s[<link rel="stylesheet" type="text/css" href="/a/w/e/some.css" />]
  end

  test "div tag" do
    assert div(nil) |> flush == "<div></div>"
    assert div("")  |> flush == "<div></div>"
    assert div([])  |> flush == "<div></div>"
    assert div("heyy") |> flush == "<div>heyy</div>"
    assert div([class: "foo"], "bar") |> flush ==
      ~s[<div class="foo">bar</div>]

    assert(
      div([class: "foo"], [
        "something",
        div([class: "other"],
          "otherthing")
      ]) |> flush ==
      ~s[<div class="foo">something<div class="other">otherthing</div></div>])
  end

  test "grid fun" do
    assert( grid([container: 16], "foo") |> flush ==
      ~s[<div class="container_16">foo</div>] )
    assert( grid([container: 16, id: 1], "foo") |> flush ==
      ~s[<div class="container_16" id="1">foo</div>] )
    assert( grid([:alpha], "foo") |> flush ==
      ~s[<div class="alpha">foo</div>] )
    assert( grid([:alpha, prefix: 2, wide: 3, suffix: 1], "foo") |> flush ==
      ~s[<div class="alpha prefix_2 grid_3 suffix_1">foo</div>] )
    assert( grid([:omega, wide: 4], "foo") |> flush ==
      ~s[<div class="omega grid_4">foo</div>] )
    assert( grid([class: "aux", wide: 4], "foo") |> flush ==
      ~s[<div class="aux grid_4">foo</div>] )
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

