defmodule IntegrationLayer.ACL do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    if authorized?(conn) do
      # Further mutate the request for
      # as needed upstream service
      conn
    else
      conn
      |> send_resp(403, "Unauthorized request.")
      |> halt
    end
  end

  def authorized?(_conn) do
    # actual auth logic goes here.
    true
  end
end
