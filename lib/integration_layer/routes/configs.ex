defmodule IntegrationLayer.Routes.Configs do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    conn = fetch_query_params(conn)
    path = conn.params["path"]

    [{ _key, value }] = :ets.lookup(:my_configs, path)

    send_resp(conn, 200, ~s(Config for "#{inspect path}" is #{inspect value}))
  end

  put "/" do
    conn  = fetch_query_params(conn)

    path  = conn.params["path"]
    key   = conn.params["key"]
    value = conn.params["value"]

    [{ _key, existing_config }] = :ets.lookup(:my_configs, path)

    new_config = Map.put(existing_config, String.to_atom(key), value)
    :ets.insert(:my_configs, { path, new_config })

    send_resp(conn, 200, "Successfully updated config for #{inspect key} with #{inspect value}")
  end
end
