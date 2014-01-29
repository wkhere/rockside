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

  def html(inner), do: tag(:html, inner)
end

defmodule Rockside.Sanity do
  import Plug.Connection
  import Rockside.Doc

  def call(conn, []) do
    doc = html [
      tag(:head),
      tag(:body, "foo")
    ]
    conn = conn
      |> put_resp_content_type("text/html")
      |> send_resp(200, finish doc)
    {:ok, conn}
  end
end

