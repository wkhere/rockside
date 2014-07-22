defmodule Rockside.Sanity.Doc.Bench do
  use Benchfella
  alias Rockside.Sanity.Doc

  bench "doc via elements api" do
    Doc.ViaElements.doc
  end

  # idea is to but here other Sanity.Doc representations
  # coded in different layers / DSLs
end
