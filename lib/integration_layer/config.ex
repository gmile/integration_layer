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

      :ets.tab2list(:my_configs)

      [{_key, config}] = :ets.lookup(:my_configs, key)

      conn
      |> assign(:config, config)
    end
  end
end
