defmodule Api.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.Accounts.Session

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "sessions" do
    field(:data, :map)
    field(:ip, :string)
    field(:user_agent, :string)

    timestamps()
  end

  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:data, :ip, :user_agent]) 
  end
end