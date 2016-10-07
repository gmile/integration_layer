defmodule IntegrationLayer.Routes.Configs do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    conn = fetch_query_params(conn)
    path = conn.params["path"]

    [{ _key, value }] = :ets.match_object(:my_configs, {:_, %{ from: path }})

    send_resp(conn, 200, "Config for #{inspect path} is #{inspect value}")
  end

  put "/" do
    conn  = fetch_query_params(conn)

    path  = conn.params["path"]
    key   = conn.params["key"]
    value = conn.params["value"]

    [{ tabkey, existing_config }] = :ets.match_object(:my_configs, {:_, %{ from: path }})

    new_config = Map.put(existing_config, String.to_atom(key), value)
    :ets.insert(:my_configs, { tabkey, new_config })

    send_resp(conn, 200, "Successfully updated config for #{inspect path}: #{inspect key} is now #{inspect value}")
  end
end
