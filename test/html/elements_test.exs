defmodule Rockside.HTML.Elements.Test do
  use ExUnit.Case
  import Rockside.HTML.Elements
  use Rockside.HTML.Elements # hack for shadowing div
  import Rockside.HTML.TestHelper


  test "html has doctype" do
    assert html([]) |> flush =~ "<!DOCTYPE html>"
  end
 
  test "html tag attributes" do
    assert html([foo: "bar"], nil) |> flush =~
      ~s[<html foo="bar"></html>]
  end

  test "meta tag" do
    assert meta()   |> flush == "<meta />"
    assert meta([]) |> flush == "<meta />"
  end

  test "link tag" do
    assert link()   |> flush == "<link />"
    assert link([]) |> flush == "<link />"
    assert link([foo: "bar"]) |> flush == ~s[<link foo="bar" />]
  end

  test "css" do
    assert css("/a/w/e/some.css") |> flush ==
      ~s[<link rel="stylesheet" type="text/css" href="/a/w/e/some.css" />]
  end

  test "script" do
    assert script(src: "foo.js") |> flush ==
      ~s[<script type="text/javascript" src="foo.js"></script>]
    assert script("$('#main')") |> flush ==
      ~s[<script type="text/javascript">$('#main')</script>]
  end

  test "title tag" do
    assert title() |> flush == "<title></title>"
    assert title("foo") |> flush == "<title>foo</title>"
  end

  test "div tag" do
    assert div()    |> flush == "<div></div>"
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

  test "span tag" do
    assert span() |> flush == "<span></span>"
    assert span([class: "foo"], "bar") |> flush ==
      ~s[<span class="foo">bar</span>]
  end

  test "p tag" do
    assert p() |> flush == "<p></p>"
    assert p("content") |> flush == "<p>content</p>"
  end

  test "a tag" do
    assert a() |> flush == "<a></a>"
    assert a([href: "link"], "desc") |> flush ==
      ~s[<a href="link">desc</a>]
  end

  test "br tag" do
    assert br() |> flush == "<br />"
  end

  test "img tag" do
    assert img([src: "pic"]) |> flush ==
      ~s[<img src="pic" />]
  end

  test "grid" do
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
    assert( grid([style: "quux"], "foo") |> flush ==
      ~s[<div style="quux">foo</div>] )

    # Class goes first in output, but the order of non-class
    # (this includes non-grid) attrs is preserved.
    # Also the order of class/grid values in the resulting class
    # should be preserved. Here are the checks:

    # resulting class attr goes first:
    assert( grid([class: "aux", wide: 4, style: "quux"], "foo") |> flush ==
      ~s[<div class="aux grid_4" style="quux">foo</div>] )
    assert( grid([style: "quux", class: "aux", wide: 4], "foo") |> flush ==
      ~s[<div class="aux grid_4" style="quux">foo</div>] )
    assert( grid([class: "aux", style: "quux", wide: 4], "foo") |> flush ==
      ~s[<div class="aux grid_4" style="quux">foo</div>] )
    # non-class attrs order:
    assert( grid([a: "quux", b: "bar"], "foo") |> flush ==
      ~s[<div a="quux" b="bar">foo</div>] )
    assert( grid([b: "quux", a: "bar"], "foo") |> flush ==
      ~s[<div b="quux" a="bar">foo</div>] )
    # non-class attrs mixed with class/grid:
    assert( grid([a: "quux", class: "aux", b: "bar", wide: 1], "foo") |> flush ==
      ~s[<div class="aux grid_1" a="quux" b="bar">foo</div>] )
    assert( grid([b: "quux", class: "aux", a: "bar", wide: 1], "foo") |> flush ==
      ~s[<div class="aux grid_1" b="quux" a="bar">foo</div>] )
    # order of class/grid values is preserved:
    assert( grid([wide: 4, class: "aux"], "foo") |> flush ==
      ~s[<div class="grid_4 aux">foo</div>] )
    assert( grid([wide: 4, class: "aux", style: "quux"], "foo") |> flush ==
      ~s[<div class="grid_4 aux" style="quux">foo</div>] )
    assert( grid([b: "quux", wide: 1, a: "bar", class: "aux"], "foo") |> flush ==
      ~s[<div class="grid_1 aux" b="quux" a="bar">foo</div>] )
  end
end
