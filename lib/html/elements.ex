defmodule Rockside.HTML.Elements do
  import Rockside.HTML.TagBase
  import Kernel, except: [div: 2]
  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [div: 2]
    end
  end

  @type attrs    :: TagBase.attrs
  @type content  :: TagBase.content
  @type out_tag  :: TagBase.out_tag
  @type out_tag1 :: TagBase.out_tag1
  # is it a bug in Elixir that above is needed?


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


  @spec script(attrs | String.t) :: out_tag

  def script(src: link) do
    tag(:script, [type: "text/javascript", src: link], [])
  end
  def script(text) do
    tag(:script, [type: "text/javascript"], text)
  end

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
