defmodule BenchHelper do
  def rand(x) when is_integer(x), do: :random.uniform(x)
  def rand(coll) when is_list(coll), do: coll |> Enum.shuffle |> hd
end

defmodule Rockside.HTML.Elements.Bench do
  use Benchfella
  import Rockside.HTML.Elements
  import BenchHelper

  @grid_attrs \
    [{:wide, rand(16)},  {rand([:preffix,:suffix]), rand(16)}]
      |> Enum.into(rand([[], [:alpha], [:omega]]))
      |> Enum.into([ rand([] ++ (for x <- [:class,:id,:style], do: {x, :val})) ])

  bench "grid element creation" do
    grid(@grid_attrs, [])
  end
end
