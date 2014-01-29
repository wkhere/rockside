defmodule Rockside do
  def run_sanity() do
    Plug.Adapters.Cowboy.http Rockside.Sanity, []
  end
end

defmodule Rockside.Doc do

  def tag(tag, inner//[]) do
    ["<#{tag}>", inner, "</#{tag}>"]
  end

  def finish(chunks), do: chunks |> List.flatten |> Enum.join

  %w[html head body]
    |> Enum.each fn (name) ->
      sym = :"#{name}"
      def unquote(sym)(inner//[]), do: tag(unquote(sym), inner)
    end
end

defmodule Rockside.Sanity do
  import Plug.Connection
  import Rockside.Doc

  def call(conn, []) do
    doc = html [
      head,
      body "foo"
    ]
    conn = conn
      |> put_resp_content_type("text/html")
      |> send_resp(200, finish doc)
    {:ok, conn}
  end
end

