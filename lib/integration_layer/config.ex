defmodule IntegrationLayer.Config do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    # this is the config we'll have
    # to read from ets OR mnesia
    config = %{
      a: 1,
      b: 2
    }

    conn
    |> assign(:config, config)
  end
end
