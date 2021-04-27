defmodule Api.Sites do
  import Ecto.Query, warn: false

  alias Api.{Repo, Tools}
  alias Api.Sites.Site

  def create_site(attrs) do
    %Site{}
    |> Site.changeset(attrs)
    |> Repo.insert()
  end

  def update_site(site, attrs) do
    site
    |> Site.changeset(attrs)
    |> Repo.update()
  end

  def get_site_by_id(id) do
    site =
      Site
      |> where([s], s.id == ^id and not s.is_deleted)
      |> Repo.one()

    if site, do: {:ok, site}, else: {:error, :site_not_existed}
  end
  
  def get_all_site(account_id, params) do
    {page, limit} = Tools.get_page_limit_from_params(params)
    offset = (page - 1) * limit
    term = if Tools.is_empty?(params["term"]), do: nil, else: params["term"]
    query =
      Site
      |> where([s], s.creator_id == ^account_id and not s.is_deleted)
    
    query =
      if Tools.is_empty?(params["term"]) do
        query
      else
        query
        |> where([s], ilike(s.name, ^"%#{params["term"]}%"))
      end

    total_entries =
      query
      |> select([s], count(s.id))
      |> Repo.one()

    data =
      query
      |> order_by([s], [desc: s.inserted_at])
      |> offset([s], ^offset)
      |> limit([s], ^limit)
      |> Repo.all()

    sites = %{
      data: data,
      total_entries: total_entries,
      page: page,
      limit: limit,
      term: term
    }
    {:ok, sites}
  end
end