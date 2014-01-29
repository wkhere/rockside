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
end
