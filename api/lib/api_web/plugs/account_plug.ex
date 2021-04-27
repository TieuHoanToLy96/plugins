defmodule ApiWeb.Plug.AccountPlug do
  import Plug.Conn

  alias Api.Accounts

  def init(opts), do: opts

  def call(conn, _) do
    token_claims = conn.assigns.token_claims

    with {:ok, account} <- Accounts.get_account_by_id(token_claims["account_id"]) do
      cond do
        account.status > 0 ->
          assign(conn, :account, account)

        account.status < 0 ->
          send_resp(conn, 403, "Banned for bad behaviors!")
          |> halt()

        true ->
          send_resp(conn, 404, "Deleted!")
          |> halt()
      end
    else
      _ ->
        send_resp(conn, 403, "Forbidden!")
        |> halt()
    end
  end
end
