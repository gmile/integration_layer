defmodule IntegrationLayer do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    :ets.new(:my_configs, [:named_table, :public, :set])

    :ets.insert(:my_configs, {"/user/create", %{ upstream_path: "https://example.com/sync/work" }})
    :ets.insert(:my_configs, {"/user/create_async", %{ upstream_path: "https://example.com/async/work" }})

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, IntegrationLayer.Router, [], [port: 4000])
    ]

    opts = [strategy: :one_for_one, name: IntegrationLayer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
