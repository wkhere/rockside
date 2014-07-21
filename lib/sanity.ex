defmodule Rockside.Sanity do
  import Plug.Conn
  import Rockside.HTML.Elements

  def init(opts), do: opts

  def call(conn, []) do
    doc = html [
      head([
        meta([http_equiv: "Content-Type", content: "text/html"]),
        title("foo"),
      ]),
      body("foo")
    ]
    conn = conn
      |> put_resp_content_type("text/html")
      |> send_resp(200, doc)
    conn
  end
end
