defmodule RocksideTest do
  use ExUnit.Case
  import Rockside.Doc

  test "content nested between tags" do
      assert (( finish body "foo" ) == "<body>foo</body>")
  end

  test "nested tags" do
    assert (( finish html [body] ) =~ "<html><body></body></html>")
  end

  test "html has doctype" do
    assert (( finish html [] ) =~ "<!DOCTYPE html>")
  end

  test "tag attributes" do
    assert (( finish tag(:foo, [class: "bar"], nil) ) ==
      %s[<foo class="bar"></foo>])
  end

  test "tag attributes plus content" do
    assert (( finish tag(:foo, [class: "bar"], "quux") ) ==
      %s[<foo class="bar">quux</foo>])
  end

  test "html tag attributes" do
    assert (( finish html [foo: "bar"], nil ) =~
      %s[<html foo="bar"></html>])
  end

end
