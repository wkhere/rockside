alias Rockside.HTML

defmodule HTML.TagBase do

  alias HTML.Assembly.Types, as: T
  import HTML.Assembly.Tools, only: [htmlize_attrs: 1]

  @spec tag(T.tagname, T.attrs, T.content)  :: T.out_tag
  @spec tag(T.tagname)                      :: T.out_tag

  def tag(tag, attrs\\[], inner)

  def tag(tag, [], inner) do
    ["\n<#{tag}>", inner, "</#{tag}>"]
  end
  def tag(tag, attrs, inner) do
    ["\n<#{tag} ", htmlize_attrs(attrs), ">", inner, "</#{tag}>"]
  end

  def tag(tag), do: tag(tag, [], [])


  @spec tag1(T.tagname, T.attrs) :: T.out_tag1

  def tag1(tag, attrs\\[])

  def tag1(tag, []) do
    ["<#{tag} />"]
  end
  def tag1(tag, attrs) do
      ["\n<#{tag} ", htmlize_attrs(attrs), " />"]
  end
end
