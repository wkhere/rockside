ExUnit.start

defmodule Rockside.HTML.TestHelper do
  def flush(doc) do
    doc |> Rockside.HTML.TagBase.Tools.flush |> String.replace("\n", "")
  end
end
