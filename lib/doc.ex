defmodule Rockside.Doc do
  import Kernel, except: [div: 2]

  @type tagname  :: atom
  @type attrs :: [{atom, String.t}]
  @type content :: String.t | list
  @type outlist  :: [any(), ...]
  @type out_tag1 :: [[String.t] | String.t] | String.t

  @spec tag(tagname, attrs, content)  :: outlist
  @spec tag(tagname)                  :: outlist

  def tag(tag, attrs\\[], inner)

  def tag(tag, [], inner) do
    ["<#{tag}>", inner, "</#{tag}>"]
  end
  def tag(tag, attrs, inner) do
    ["<#{tag} ", htmlize_attrs(attrs), ">", inner, "</#{tag}>"]
  end

  def tag(tag), do: tag(tag, [], [])


  @spec tag1(tagname, attrs) :: out_tag1

  def tag1(tag, attrs\\[])

  def tag1(tag, []) do
    "<#{tag} />"
  end
  def tag1(tag, attrs) do
      ["<#{tag} ", htmlize_attrs(attrs), " />"]
  end


  @spec flush(outlist | String.t) :: String.t

  def flush(chunks) when is_list(chunks) do
    chunks |> List.flatten |> Enum.join
  end
  def flush(chunk) when is_binary(chunk), do: chunk
  # ^ needed only for plug-free tests, because patched Plug
  # accepts iolist as a resp body


  @spec html(attrs, list) :: outlist

  def html(attrs\\[], inner) do
    [ "<!DOCTYPE html>" | tag(:html, attrs, inner) ]
  end


  ~w[head title body div]
    |> Enum.each fn name ->
      sym = :"#{name}"
      @spec unquote(sym)(attrs, content) :: outlist
      @spec unquote(sym)() :: outlist
      def unquote(sym)(attrs\\[], inner), do: tag(unquote(sym), attrs, inner)
      def unquote(sym)(), do: tag(unquote(sym))
    end

  ~w[meta link]
    |> Enum.each fn name ->
      sym = :"#{name}"
      @spec unquote(sym)(attrs) :: out_tag1
      def unquote(sym)(attrs\\[]), do: tag1(unquote(sym), attrs)
    end


  @spec css(String.t) :: out_tag1

  def css(path), do: link([rel: "stylesheet", type: "text/css", href: path])


  @spec grid(list, content) :: outlist

  def grid(args, body) when is_list(args) do
    args = args |> Enum.map(fn
        {:container, v} -> {:class, "container_#{v}"}
        {:prefix, v}    -> {:class, "prefix_#{v}"}
        {:suffix, v}    -> {:class, "suffix_#{v}"}
        {:wide, v}      -> {:class, "grid_#{v}"}
        x when x in [:clear,:alpha,:omega] -> {:class, x}
        {k,v}           -> {k,v}
      end)
    joint_class = (for {:class,c} <- args, do: c) |> Enum.join(" ")
    unless joint_class == "" do
      args = args |> Enum.reject(fn {k,_} -> k == :class end)
        |> Keyword.put(:class, joint_class)
    end
    div(args, body)
  end


  @spec htmlize_attrs(attrs) :: [String.t]

  defp htmlize_attrs(attrs) do
    Enum.map(attrs, fn {k,v} ->
      k = k |> to_string |> String.replace("_", "-")
      ~s/#{k}="#{v}"/
    end)
      |> Enum.intersperse(" ")
  end
end
