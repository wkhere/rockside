alias Rockside.HTML
alias HTML.TagBase

defmodule TagBase.Test do
  use    ExUnit.Case
  import HTML.TestHelper
  import TagBase

  test "content nested between tags" do
    assert tag(:body, "foo") |> flush == "<body>foo</body>" 
  end

  test "nested tags" do
    assert tag(:html, tag(:body)) |> flush =~ "<html><body></body></html>"
  end

  test "tag without attributes or content" do
    assert tag(:foo) |> flush == ~s[<foo></foo>]
  end

  test "tag without attributes" do
    assert tag(:foo, "content") |> flush == ~s[<foo>content</foo>]
  end

  test "tag attributes" do
    assert tag(:foo, [class: "bar"], []) |> flush ==
      ~s[<foo class="bar"></foo>]
    # make sure the order is preserved:
    assert tag(:foo, [class: "bar", other: "quux"], []) |> flush ==
      ~s[<foo class="bar" other="quux"></foo>]
    assert tag(:foo, [other: "quux", class: "bar"], []) |> flush ==
      ~s[<foo other="quux" class="bar"></foo>]
  end

  test "tag attributes plus content" do
    assert tag(:foo, [class: "bar"], "quux") |> flush ==
      ~s[<foo class="bar">quux</foo>]
    # make sure the order is preserved:
    assert tag(:foo, [class: "bar", other: "quux"], "hello") |> flush ==
      ~s[<foo class="bar" other="quux">hello</foo>]
    assert tag(:foo, [other: "quux", class: "bar"], "hello") |> flush ==
      ~s[<foo other="quux" class="bar">hello</foo>]
  end

  test "tag1 without attributes" do
    assert tag1(:foo) |> flush == ~s[<foo />]
  end

  test "tag1 with attributes" do
    assert tag1(:foo, [class: "bar"]) |> flush == ~s[<foo class="bar" />]
    # make sure the order is preserved:
    assert tag1(:foo, [class: "bar", other: "quux"]) |> flush ==
      ~s[<foo class="bar" other="quux" />]
    assert tag1(:foo, [other: "quux", class: "bar"]) |> flush ==
      ~s[<foo other="quux" class="bar" />]
  end

end
