defmodule IntegrationLayer.Router do
  use Plug.Router

  plug IntegrationLayer.Config
  plug IntegrationLayer.Auth
  plug IntegrationLayer.ACL

  forward "/configs", to: IntegrationLayer.Routes.Configs
  forward "/user", to: IntegrationLayer.Routes.Users

  plug :match
  plug :dispatch
end
