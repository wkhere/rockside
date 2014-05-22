# todo: test using Plug.Test

defmodule RocksideTest do
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

  test "tag attributes" do
    assert tag(:foo, [class: "bar"], nil) |> flush ==
      ~s[<foo class="bar"></foo>]
  end

  test "tag attributes plus content" do
    assert tag(:foo, [class: "bar"], "quux") |> flush ==
      ~s[<foo class="bar">quux</foo>]
  end

  test "html tag attributes" do
    assert html([foo: "bar"], nil) |> flush =~
      ~s[<html foo="bar"></html>]
  end

end
