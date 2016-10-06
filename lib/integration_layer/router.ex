defmodule IntegrationLayer.Router do
  use Plug.Router

  plug :match

  plug IntegrationLayer.Config
  plug IntegrationLayer.Auth
  plug IntegrationLayer.ACL

  plug :dispatch

  post "/create_user" do
    # 1. read the config
    # 2. some actual work was done here

    send_resp(conn, 200, "Sucessfully created a user (sync)!")
  end

  post "/create_user_async" do
    # read config to establish where to forward /create_user_async to
    # let's say it's https://google.com/ for now

    conn =
      conn
      |> fetch_query_params

    # conn.params["callback_url"]

    req_callback_url = "http://requestb.in/s7wnp7s7"
    url_from_config = "https://google.com"

    Task.async fn ->
      response = HTTPoison.get!(url_from_config, conn.req_headers).body
      HTTPoison.post!(req_callback_url, response)
    end

    send_resp(conn, 200, "Successfully scheduled creating a user! Once we're done, we'll send a reply to #{req_callback_url}")
  end
end
