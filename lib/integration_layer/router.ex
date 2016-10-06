defmodule IntegrationLayer.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/authorize" do
    send_resp(conn, 200, "Sucessfully authorize!")
  end

  post "/create_user" do
    send_resp(conn, 200, "Sucessfully created a user!")
  end

  get "/acl" do
    send_resp(conn, 200, "Sucessfully checked against an Access Control List!")
  end
end
