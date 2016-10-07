defmodule IntegrationLayer.Config do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    # let's say our keys are "paths".
    # probably should be something smarter than that. "clients" like in Kong?

    if conn.path_info == ["configs"] do
      conn
    else
      key = "/" <> Enum.join(conn.path_info, "/")

      # "from" is hardcoded here
      [{_key, config}] = :ets.match_object(:my_configs, {:_, %{ from: key }})

      conn
      |> assign(:config, config)
    end
  end
end
