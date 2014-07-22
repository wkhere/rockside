defmodule Rockside.Sanity do
  import Plug.Conn

  defmodule Doc.ViaElements do
    def doc do
      import Rockside.HTML.Elements
      html [
        head([
          meta([http_equiv: "Content-Type", content: "text/html"]),
          title("foo"),
        ]),
        body("foo")
      ]
    end
  end

  def init(opts), do: opts

  def call(conn, []) do
    import Doc.ViaElements
    conn = conn
      |> put_resp_content_type("text/html")
      |> send_resp(200, doc)
    conn
  end
end
