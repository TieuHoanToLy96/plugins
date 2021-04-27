defmodule Api.Accounts do
  import Ecto.Query, warn: false

  alias Api.Repo
  alias Api.Guardian
  alias Api.Accounts.{Account, Session}

  def get_account_by_id(id) do
    query = from a in Account, where: a.id == ^id

    if acc = Repo.one(query), do: {:ok, acc}, else: {:error, :entity_not_exist}
  end

  def get_account_by_email(email) do
    query = from a in Account, where: a.email == ^email
    if acc = Repo.one(query), do: {:ok, acc}, else: {:error, :entity_not_exist}
  end

  def create_account(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  def create_session_by_account(conn, account, ip \\ nil, user_agent \\ nil) do
    params = %{
      email: account.email,
      account_id: account.id,
      first_name: account.first_name,
      last_name: account.last_name
    }

    remote_ip = ip || conn.remote_ip |> Tuple.to_list() |> Enum.join(".")

    user_agent =
      user_agent || for({"user-agent", data} <- conn.req_headers, do: data) |> List.first()

    attrs = %{
      data: %{account_info: params},
      ip: remote_ip,
      user_agent: user_agent
    }

    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end
  

  def get_jwt(account_id) do
    account = get_account_by_id(account_id) |> elem(1)
    claims = %{
      "email" => account.email,
      "account_id" => account.id
    } 
    Api.Guardian.encode_and_sign(account, claims, ttl: {52, :weeks}, some: "secret")
    |> elem(1)
  end
end