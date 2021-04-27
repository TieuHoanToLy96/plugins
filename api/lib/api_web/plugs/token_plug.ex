defmodule ApiWeb.Plug.TokenPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    IO.inspect(label: "tessss")
    conn = fetch_cookies(conn)

    authorization = for({"authorization", auth} <- conn.req_headers, do: auth) |> List.first()
    
    case authorization do
      "Bearer " <> jwt ->
        IO.inspect(jwt, label: "jwttttt")
        case Api.Guardian.decode_and_verify(jwt) do
          {:ok, claims} ->
            assign(conn, :token_claims, claims)

          _ ->
            verify_from_cookie(conn)
        end

      _ ->
        verify_from_cookie(conn)
    end
  end

  defp verify_from_cookie(conn) do
    token_from_cookie = conn.req_cookies["jwt"]
    case Api.Guardian.decode_and_verify(token_from_cookie || "") do
      {:ok, claims}  ->
        assign(conn, :token_claims, claims)

      _ ->
        send_resp(conn, 401, "Unauthorized! Passport")
        |> halt()
    end
  end
end

 