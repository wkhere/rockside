defmodule Rockside.Sanity.Doc.Bench do
  use Benchfella
  alias Rockside.Sanity.Doc

  bench "doc via dsl" do
    Doc.ViaDSL.doc
  end
end
