defmodule Api.Sites.Site do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Sites.Site
  alias Api.Accounts.Account
  alias Api.Repo

  schema "sites" do
    field :name, :string
    field :url, :string
    field :is_deleted, :boolean, default: false
    belongs_to(:creator, Account, type: Ecto.UUID)
    belongs_to(:owner, Account, type: Ecto.UUID)

    timestamps()
  end

  def changeset(%Site{} = site, attrs) do
    site
    |> cast(attrs, [:name, :url, :is_deleted, :owner_id, :creator_id])
  end

  def json(%Site{} = site) do
    data = Map.take(site, [:id, :name, :url, :is_deleted, :owner_id, :creator_id, :inserted_at, :updated_at])
    data =
      case Map.fetch(site, :creator) do
        {:ok, %Ecto.Association.NotLoaded{}} ->
          site = Repo.preload(site, :creator)
          Map.put(data, :creator, Account.json(site.creator))

        {:ok, value} ->
          Map.put(data, :creator, Account.json(value))

        _ ->
          data
      end
    data
  end

  def json(sites) when is_list(sites) do
    Enum.map(sites, & json(&1))
  end
end