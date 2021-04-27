defmodule ApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ApiWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(ApiWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:failed, :with_reason, msg}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{success: false, message: msg, fallback: "with_reason"})
  end

  def call(conn, {:failed, :with_reason, msg, reason}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{success: false, message: msg, fallback: "with_reason", reason: reason})
  end

  def call(conn, {:error, :internal_server_error}) do
    conn
    |> send_resp(
      :internal_server_error,
      Jason.encode!(%{
        error: "Internal Server Error",
        fallback: "internal_server_error"
      })
    )
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(ApiWeb.ErrorView, :"404")
  end

  def call(conn, {:error, :api_bad_request}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{
      success: false,
      message: "Params is incorrect or missing!",
      fallback: "api_bad_request"
    })
  end

  def call(conn, {:error, :api_bad_request, msg}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{success: false, message: msg, fallback: "api_bad_request"})
  end

  def call(conn, {:error, :api_bad_request, msg, reason}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{success: false, message: msg, fallback: "api_bad_request", reason: reason})
  end

  def call(conn, {:error, :api_auth_failed}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{success: false, message: "unauthorized", fallback: "api_auth_failed"})
  end

  def call(conn, {:error, :api_auth_failed, msg}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{success: false, message: msg, fallback: "api_auth_failed"})
  end

  def call(conn, {:error, :entity_not_existed}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{
      success: false,
      message: "This entity is not existed",
      fallback: "entity_not_existed"
    })
  end

  def call(conn, {:error, :entity_not_existed, msg}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{success: false, message: msg, fallback: "entity_not_existed"})
  end

  def call(conn, {:error, :entity_not_existed, msg, reason}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{success: false, message: msg, reason: reason, fallback: "entity_not_existed"})
  end

  def call(conn, {:existed, msg}) do
    conn
    |> put_status(:conflict)
    |> json(%{success: false, message: msg, fallback: "existed"})
  end

  def call(conn, {:existed, msg, reason}) do
    conn
    |> put_status(:conflict)
    |> json(%{success: false, message: msg, reason: reason, fallback: "existed"})
  end

  def call(conn, {:error, :entity_existed}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{success: false, message: "This entity is existed", fallback: "entity_existed"})
  end

  def call(conn, {:error, :entity_existed, msg}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{success: false, message: msg, fallback: "entity_existed"})
  end

  def call(conn, {:error, :entity_existed, msg, reason}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{success: false, message: msg, reason: reason, fallback: "entity_existed"})
  end

  def call(conn, {:failed, :datasource_not_found}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{success: false, message: "Datasource not found", fallback: "datasource_not_found"})
  end

  def call(conn, {:failed, :datasource_not_found, msg}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{success: false, message: msg, fallback: "datasource_not_found"})
  end

  def call(conn, {:failed, :datasource_not_found, msg, reason}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{success: false, message: msg, reason: reason, fallback: "datasource_not_found"})
  end

  def call(conn, {:failed, :success_false_only}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{success: false, fallback: "success_false_only"})
  end

  def call(conn, {:error, :precondition_failed}) do
    conn
    |> put_status(:precondition_failed)
    |> json(%{success: false, fallback: "precondition_failed"})
  end

  def call(conn, {:error, :precondition_failed, msg}) do
    conn
    |> put_status(:precondition_failed)
    |> json(%{success: false, message: msg, fallback: "precondition_failed"})
  end

  def call(conn, {:error, :precondition_failed, msg, reason}) do
    conn
    |> put_status(:precondition_failed)
    |> json(%{success: false, message: msg, reason: reason, fallback: "precondition_failed"})
  end

  def call(conn, {:error, :page_not_found}) do
    conn
    |> render("404.html", %{})
  end

  def call(conn, {:success, :success_only}) do
    conn
    |> put_status(:ok)
    |> json(%{success: true, fallback: "success_only"})
  end

  def call(conn, {:success, :with_data, data}) do
    conn
    |> put_status(:ok)
    |> json(%{success: true, data: data, fallback: "with_data"})
  end

  def call(conn, {:success, :with_data, key, data}) when is_bitstring(key) do
    to_send = %{success: true, fallback: "with_data"} |> Map.put(String.to_atom(key), data)

    conn
    |> put_status(:ok)
    |> json(to_send)
  end

  def call(conn, {:success, :with_data, key, data}) when is_atom(key) do
    to_send = %{success: true, fallback: "with_data"} |> Map.put(key, data)

    conn
    |> put_status(:ok)
    |> json(to_send)
  end

  def call(conn, {:success, :msg_and_data_after, msg, data}) do
    conn
    |> put_status(:ok)
    |> json(%{success: true, data: data, message: msg, fallback: "msg_and_data_after"})
  end

  def call(conn, :permission_denied) do
    conn
    |> send_resp(403, "Permission Denied!")
  end
end
