defmodule IntegrationLayer do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    configs =[
      {1, %{ from: "/user/create", to: "https://example.com/sync/work" }},
      {2, %{ from: "/user/create_async", to: "https://example.com/async/work" }}
    ]

    :ets.new(:my_configs, [:named_table, :public, :set])
    :ets.insert(:my_configs, configs)

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, IntegrationLayer.Router, [], [port: 4000])
    ]

    opts = [strategy: :one_for_one, name: IntegrationLayer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
