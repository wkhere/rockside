ExUnit.start

defmodule Rockside.HTML.TestHelper do
  def flush(doc) do
    doc |> Rockside.HTML.TagBase.flush |> String.replace("\n", "")
  end
end
