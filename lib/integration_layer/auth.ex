defmodule IntegrationLayer.Auth do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    if authenticated?(conn) do
      # Further mutate the request for
      # as needed upstream service
      conn
    else
      conn
      |> send_resp(401, "")
      |> halt
    end
  end

  def authenticated?(_conn) do
    # actual auth logic goes here.
    true
  end
end
