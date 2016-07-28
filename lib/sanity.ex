defmodule Rockside.Sanity do
  import Plug.Conn

#  defmodule Doc.ViaDSL do
#    def doc do
#      use WebAssembly
#      builder do html do
#        head do
#          meta http_equiv: "Content-Type", content: "text/html"
#          title "foo"
#        end
#        body "foo"
#      end end
#    end
#  end

  def init(opts), do: opts

  def call(conn, []) do
    #import Doc.ViaDSL
    conn = conn
      |> put_resp_content_type("text/plain")
      |> send_resp(200, "Hello World")
    conn
  end
end
