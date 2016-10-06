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
    callback_url = "http://requestb.in/s7wnp7s7"

    url_from_config = conn.assigns.config.upstream_path

    Task.async fn ->
      response = HTTPoison.get!(url_from_config, conn.req_headers).body
      HTTPoison.post!(callback_url, response)
    end

    send_resp(conn, 200, "Successfully scheduled creating a user! Once we're done, we'll send a reply to #{callback_url}")
  end
end
