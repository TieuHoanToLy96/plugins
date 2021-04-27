defmodule ApiWeb.AuthController do
  use ApiWeb, :controller
  alias Api.{Accounts, Guardian}
  action_fallback ApiWeb.FallbackController

  def oauth2_login(conn, params) do
    IO.inspect(params, label: "paramsss")
    ip = params["ip"]
    user_agent = params["user_agent"]

    me =
      HTTPoison.get("#{System.get_env("AUTH_URL")}/api/v1/users/@me", [
        {"Authorization", "Bearer " <> params["access_token"]}
      ])

    case me do
      {:ok, %HTTPoison.Response{body: body}} ->
        payload = Jason.decode!(body)

        {account, session} =
          case Accounts.get_account_by_email(payload["user"]["email"]) do
            {:error, :entity_not_exist} ->
              attrs =
                payload["user"]
                |> Map.put("pancakeid_handle", params["access_token"])

              with {:ok, account} <- Accounts.create_account(attrs),
                   {:ok, session} <-
                     Accounts.create_session_by_account(conn, account, ip, user_agent) do
                {account, session}
              else
                _ ->
                  {nil, nil}
              end

            {:ok, account} ->
              with {:ok, session} <-
                     Accounts.create_session_by_account(conn, account, ip, user_agent) do
                {account, session}
              else
                _ ->
                  {nil, nil}
              end
          end

        login_with_account_and_session(conn, account, session)

      _ ->
        {:failed, :with_reason, "Cannot create user session!"}
    end
  end

  defp login_with_account_and_session(_conn, account, session) do
    claims = %{
      "email" => account.email,
      "account_id" => account.id
    } 

    Guardian.encode_and_sign(account, claims, ttl: {52, :weeks}, some: "secret") |> IO.inspect(label: "resssss")
    |> case do
      {:ok, jwt, _claims} -> 
        {:success, :with_data, "session", %{"session_id" => session.id, "jwt" => jwt}}
      _ ->
        {:failed, :with_reason, "Cannot create jwt!"}
    end
  end
end
