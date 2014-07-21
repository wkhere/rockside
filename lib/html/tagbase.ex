defmodule Rockside.HTML.TagBase do

  @type tagname  :: atom
  @type attrs    :: [{atom, String.t}]
  @type content  :: String.t | out_tag | [String.t | out_tag]
  @type out_tag1 :: [String.t | [String.t]]
  @type out_tag  :: [String.t | [String.t] | content]

  @spec tag(tagname, attrs, content)  :: out_tag
  @spec tag(tagname)                  :: out_tag

  def tag(tag, attrs\\[], inner)

  def tag(tag, [], inner) do
    ["\n<#{tag}>", inner, "</#{tag}>"]
  end
  def tag(tag, attrs, inner) do
    ["\n<#{tag} ", htmlize_attrs(attrs), ">", inner, "</#{tag}>"]
  end

  def tag(tag), do: tag(tag, [], [])


  @spec tag1(tagname, attrs) :: out_tag1

  def tag1(tag, attrs\\[])

  def tag1(tag, []) do
    ["<#{tag} />"]
  end
  def tag1(tag, attrs) do
      ["\n<#{tag} ", htmlize_attrs(attrs), " />"]
  end


  @spec flush(out_tag) :: String.t

  def flush(chunks) when is_list(chunks) do
    chunks |> List.flatten |> Enum.join
  end
  # flush/1 needed only for plug-free tests, because patched Plug
  # accepts iolist as a resp body


  @spec htmlize_attrs(attrs) :: [String.t]

  defp htmlize_attrs(attrs) do
    Enum.map(attrs, fn {k,v} ->
      k = k |> to_string |> String.replace("_", "-")
      ~s/#{k}="#{v}"/
    end)
      |> Enum.intersperse(" ")
  end
end
