alias Rockside.HTML
alias HTML.Assembly

defmodule Assembly.UsingTagBase.Test do
  use    ExUnit.Case
  import HTML.TestHelper
  import HTML.TagBase
  import Assembly.St

  test "push one tag" do
    assert new |> push(tag(:foo, "bar")) |> release |> flush
      == "<foo>bar</foo>"
  end

  test "push two tags" do
    assert new
      |> push(tag(:foo, "1"))
      |> push(tag(:bar, "2"))
      |> release
      |> flush
      == """
      <foo>1</foo>
      <bar>2</bar>
      """ |> no_indent |> no_lf
  end

  test "push two tags nested and a third sister to first" do
    assert new
      |> push(tag(:foo,
          new
          |> push(tag(:bar, "inner"))
          |> release
        ))
      |> push(tag(:quux, "sister"))
      |> release
      |> flush
      == """
      <foo>
        <bar>inner</bar>
      </foo>
      <quux>sister</quux>
      """ |> no_indent |> no_lf
  end

  test "mix nesting and a list content" do
    assert new
      |> push(tag(:foo, [
          "inner",
          new
          |> push(tag(:bar, "child"))
          |> release
        ]))
      |> push(tag(:quux, "sister"))
      |> release
      |> flush
      === """
      <foo>
        inner
        <bar>child</bar>
      </foo>
      <quux>sister</quux>
      """ |> no_indent |> no_lf
  end

  test "push two sister tags and then two nested in 2nd sis" do
    assert new
      |> push(tag(:foo, "sister"))
      |> push(tag(:bar,
          new
          |> push(tag(:quux, "inner"))
          |> push(tag(:cosmic, "inner as well"))
          |> release
        ))
      |> release
      |> flush
      == """
      <foo>sister</foo>
        <bar>
        <quux>inner</quux>
        <cosmic>inner as well</cosmic>
      </bar>
      """ |> no_indent |> no_lf
  end

end
