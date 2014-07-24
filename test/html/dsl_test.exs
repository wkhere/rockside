alias Rockside.HTML

defmodule DSL.Test do
  use    ExUnit.Case
  import HTML.TestHelper
  import HTML.DSL

  test "basic builder" do
    buf = builder do
      st = st |> St.push :x
      _foo = "anything in between"
      st = st |> St.push :y
    end
    assert buf == [:x, :y]
  end

  test "builder with one content tag" do
    buf = builder do
      tag :foo, "content"
    end
    assert buf == ["<foo>", "content", "</foo>"]
  end

  test "builder with mixed level divs, no single enclosing element" do
    buf = builder do
      div "foo"
      div do
        div "bar"
      end
    end
    assert buf |> flush == """
      <div>foo</div>
      <div>
        <div>bar</div>
      </div>
      """
      |> no_indent |> no_lf
  end

  test "one step at the time ;)" do
    buf = builder do
      div do
        text "foo"
        div do
          text "inner"
        end
        text ["bar", "quux"]
      end
    end
    assert buf  |> flush == """
      <div>
        foo
        <div>
          inner
        </div>
        barquux
      </div>
      """
      |> no_indent |> no_lf
  end

end
