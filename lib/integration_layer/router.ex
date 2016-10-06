defmodule IntegrationLayer.Router do
  use Plug.Router

  plug :match

  plug IntegrationLayer.Config
  plug IntegrationLayer.Auth
  plug IntegrationLayer.ACL

  plug :dispatch

  get "/config" do
    conn  = fetch_query_params(conn)
    path   = conn.params["config_path"]

    [{ _key, value }] = :ets.lookup(:my_configs, path)

    send_resp(conn, 200, ~s(Config for "#{inspect path}" is #{inspect value}))
  end

  put "/config" do
    conn  = fetch_query_params(conn)
    path  = conn.params["config_path"]

    key   = conn.params["config_key"]
    value = conn.params["config_value"]

    [{ _key, existing_config }] = :ets.lookup(:my_configs, path)
    |> IO.inspect

    new_config = Map.put(existing_config, String.to_atom(key), value)
    :ets.insert(:my_configs, { path, new_config })

    send_resp(conn, 200, "Successfully updated config for #{inspect key} with #{inspect value}")
  end

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
