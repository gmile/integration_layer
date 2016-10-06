defmodule IntegrationLayer.Router do
  use Plug.Router

  plug :match

  plug IntegrationLayer.Config
  plug IntegrationLayer.Auth
  plug IntegrationLayer.ACL

  plug :dispatch


  forward "/config", to: IntegrationLayer.Routes.Config

  post "/create_user" do
    fake_response = ~s(Successfully created user using internal "#{conn.assigns.config.upstream_path}" service.)

    send_resp(conn, 200, fake_response)
  end

  post "/create_user_async" do
    conn  = fetch_query_params(conn)

    url_from_config = conn.assigns.config.upstream_path
    callback_url = conn.params["callback_url"] # "http://requestb.in/s7wnp7s7"

    Task.async fn ->
      # add some headers when sending a response to a backend
      response = HTTPoison.get!(url_from_config, conn.req_headers).body

      # add some headers when sending a response back to original requester
      HTTPoison.post!(callback_url, response)
    end

    send_resp(conn, 200, "Successfully scheduled creating a user! Once we're done, we'll send a reply to #{callback_url}")
  end
end
