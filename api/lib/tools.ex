defmodule Api.Tools do
  import Ecto.Query, warn: false
  @forbidden_keywords ["đăng nhập", "login", "mật khẩu", "password", "facebook, inc."]

  def is_empty?(val) when val in [nil, "null", "undefined", "", [], %{}, "[object Object]"],
    do: true

  def is_empty?(_), do: false

  def to_int(el) when el in [nil, "", "null", "undefined", "", [], %{}], do: 0

  def to_int(el) when is_bitstring(el) do
    case Integer.parse(el) do
      {num, ""} -> num
      {num, _} -> num
      _ -> 0
    end
  end

  def to_int(el) when is_integer(el), do: el
  def to_int(_), do: 0

  def str_to_bool(value) when is_boolean(value), do: value
  def str_to_bool("true"), do: true
  def str_to_bool("false"), do: false
  def str_to_bool(_), do: false

  def get_page_limit_from_params(params) do
    page = if !is_empty?(params["page"]), do: to_int(params["page"]), else: 1
    limit = if !is_empty?(params["limit"]), do: to_int(params["limit"]), else: 15

    {page, limit}
  end
end
