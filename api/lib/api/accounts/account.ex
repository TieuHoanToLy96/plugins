defmodule Api.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.Accounts.Account

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "accounts" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:phone_number, :string)
    field(:avatar, :string)
    field(:locale, :string)
    field(:pancakeid_handle, :string)
    field(:status, :integer)
    field(:settings, :map, default: %{})

    timestamps()
  end

  def changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:first_name, :last_name, :email, :phone_number, :avatar, :locale, :pancakeid_handle, :status, :settings]) 
  end

  def json(%Account{} = account) do
    Map.take(account, [:id, :first_name, :last_name, :email, :phone_number, :avatar])
  end
end