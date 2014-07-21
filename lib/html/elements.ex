defmodule Rockside.HTML.Elements do
  import Rockside.HTML.TagBase
  alias TagBase, as: T # for typespecs
  import Kernel, except: [div: 2]
  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [div: 2]
    end
  end


  @spec html(T.attrs, list) :: T.out_tag

  def html(attrs\\[], inner) do
    [ "<!DOCTYPE html>" | tag(:html, attrs, inner) ]
  end


  ~w[head title body div span p a]
    |> Enum.each fn name ->
      sym = :"#{name}"
      @spec unquote(sym)(T.attrs, T.content) :: T.out_tag
      @spec unquote(sym)() :: T.out_tag
      def unquote(sym)(attrs\\[], inner), do: tag(unquote(sym), attrs, inner)
      def unquote(sym)(), do: tag(unquote(sym))
    end

  ~w[meta link br img]
    |> Enum.each fn name ->
      sym = :"#{name}"
      @spec unquote(sym)(T.attrs) :: T.out_tag1
      def unquote(sym)(attrs\\[]), do: tag1(unquote(sym), attrs)
    end


  @spec css(String.t) :: T.out_tag1

  def css(path), do: link([rel: "stylesheet", type: "text/css", href: path])


  @spec script(T.attrs | String.t) :: T.out_tag

  def script(src: link) do
    tag(:script, [type: "text/javascript", src: link], [])
  end
  def script(text) do
    tag(:script, [type: "text/javascript"], text)
  end

  @spec grid(list, T.content) :: T.out_tag

  def grid(args, body) when is_list(args) do
    args = args |> Enum.map(fn
        {:container, v} -> {:class, "container_#{v}"}
        {:prefix, v}    -> {:class, "prefix_#{v}"}
        {:suffix, v}    -> {:class, "suffix_#{v}"}
        {:wide, v}      -> {:class, "grid_#{v}"}
        x when x in [:clear,:alpha,:omega] -> {:class, x}
        {k,v}           -> {k,v}
      end)
    {class_args, rest_args} = args |> Enum.partition(fn {k,_} ->
      k == :class
    end)
    unless class_args == [] do
      joint_class = class_args |> Enum.map_join(" ", fn {_,v}-> v end)
      args = rest_args |> Keyword.put(:class, joint_class)
    end
    div(args, body)
  end

end
