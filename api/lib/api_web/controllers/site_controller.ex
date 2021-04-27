defmodule ApiWeb.SiteController do
  use ApiWeb, :controller
  alias Api.Sites
  alias Api.Sites.Site
  action_fallback ApiWeb.FallbackController

  def all_site(conn, params) do
    account = conn.assigns.account
    {:ok, sites} = Sites.get_all_site(account.id, params)
    sites = Map.put(sites, :data, Site.json(sites.data))
    {:success, :with_data, "sites", sites}
  end

  def create_site(conn, params) do
    account = conn.assigns.account
    attrs =
      Map.take(params, ["name", "url"]) 
      |> Map.merge(%{"owner_id" => account.id, "creator_id" => account.id})

    with {:ok, site} <- Sites.create_site(attrs) do
      {:success, :success_only}
    end 
  end

  def update_site(conn, params) do
    attrs = Map.take(params, ["name", "url"])
    with {:ok, site} <- Sites.get_site_by_id(params["id"]),
      {:ok, updated_site} <- Sites.update_site(site, attrs) do
      {:success, :success_only}
    end
  end
end
