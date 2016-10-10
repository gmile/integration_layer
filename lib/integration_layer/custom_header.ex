defmodule IntegrationLayer.CustomHeader do
    import Plug.Conn

    def init(opts) do
        IO.inspect opts
        opts
    end

    def call(conn, opts) do
            case :ets.lookup(:headers_config, "/" <> Enum.reduce(conn.path_info, "", fn(x, acc) -> acc <> x <> "/" end)) do
                [val] -> 
                    val = val
                    |> Tuple.to_list
                    |> tl
                    |> hd
                    put_req_header(conn, "X-CustomHeader", val)                    
                _ -> conn
            end
    end
end