defmodule Rockside.Doc do
  import Kernel, except: [div: 2]
  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [div: 2]
    end
  end

  @type tagname  :: atom
  @type attrs    :: [{atom, String.t}]
  @type content  :: String.t | out_tag | [String.t | out_tag]
  @type out_tag1 :: [String.t | [String.t]]
  @type out_tag  :: [String.t | [String.t] | content]

  @spec tag(tagname, attrs, content)  :: out_tag
  @spec tag(tagname)                  :: out_tag

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
    ["<#{tag} />"]
  end
  def tag1(tag, attrs) do
      ["<#{tag} ", htmlize_attrs(attrs), " />"]
  end


  @spec flush(out_tag) :: String.t

  def flush(chunks) when is_list(chunks) do
    chunks |> List.flatten |> Enum.join
  end
  # flush/1 needed only for plug-free tests, because patched Plug
  # accepts iolist as a resp body


  @spec html(attrs, list) :: out_tag

  def html(attrs\\[], inner) do
    [ "<!DOCTYPE html>" | tag(:html, attrs, inner) ]
  end


  ~w[head title body div span p a]
    |> Enum.each fn name ->
      sym = :"#{name}"
      @spec unquote(sym)(attrs, content) :: out_tag
      @spec unquote(sym)() :: out_tag
      def unquote(sym)(attrs\\[], inner), do: tag(unquote(sym), attrs, inner)
      def unquote(sym)(), do: tag(unquote(sym))
    end

  ~w[meta link br img]
    |> Enum.each fn name ->
      sym = :"#{name}"
      @spec unquote(sym)(attrs) :: out_tag1
      def unquote(sym)(attrs\\[]), do: tag1(unquote(sym), attrs)
    end


  @spec css(String.t) :: out_tag1

  def css(path), do: link([rel: "stylesheet", type: "text/css", href: path])


  @spec script(String.t) :: out_tag

  def script(text), do: tag(:script, [type: "text/javascript"], text)


  @spec grid(list, content) :: out_tag

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
