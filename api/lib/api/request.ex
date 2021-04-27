defmodule Api.Request do
  require Logger
  alias Api.Tools
  @default_msg "Cannot perform request"

  def rq_get(url, headers \\ [], err_msg \\ @default_msg) do
    HTTPoison.get(url, headers, recv_timeout: 20000, hackney: [:insecure])
    |> handle_response(url, err_msg)
  end

  def rq_delete(url, headers \\ [], err_msg \\ @default_msg) do
    HTTPoison.delete(url, headers, recv_timeout: 20000)
    |> handle_response(url, err_msg)
  end

  def rq_json_get(url, data \\ %{}, headers \\ [], err_msg \\ @default_msg) do
    body = Jason.encode!(data)

    ssl_option =
      if String.contains?(url, "https://pos-host") ||
           String.contains?(url, "https://pos.pages.fm/api/v1/webcms") do
        [ssl: [{:versions, [:"tlsv1.2"]}]]
      else
        []
      end

    HTTPoison.get(
      url,
      [{"Content-Type", "application/json"}] ++ headers,
      [recv_timeout: 20000, body: body] ++ ssl_option
    )
    |> handle_response(url, err_msg)
  end

  def rq_json_post(url, data \\ %{}, headers \\ [], err_msg \\ @default_msg) do
    body = Jason.encode!(data)

    ssl_option =
      if String.contains?(url, "https://pos-host") ||
           String.contains?(url, "https://pos.pages.fm/api/v1/webcms") do
        [ssl: [{:versions, [:"tlsv1.2"]}]]
      else
        []
      end

    HTTPoison.post(
      url,
      body,
      [{"Content-Type", "application/json"}] ++ headers,
      [recv_timeout: 20000] ++ ssl_option
    )
    |> handle_response(url, err_msg)
  end

  def rq_json_put(url, data \\ %{}, headers \\ [], err_msg \\ @default_msg) do
    body = Jason.encode!(data)

    HTTPoison.put(
      url,
      body,
      [{"Content-Type", "application/json"}] ++ headers,
      recv_timeout: 20000
    )
    |> handle_response(url, err_msg)
  end

  #######################################
  # Helpers
  #######################################

  defp handle_response(response, url, err_msg) do
    res =
      case response do
        {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
          is_success = if status >= 200 && status <= 300, do: true, else: false

          if !is_success do
            Logger.error("Success false from #{url} with body: #{inspect(body)}")
          end

          try do
            body = if Tools.is_empty?(body), do: "{}", else: body
            body = Jason.decode!(body)
            %{"success" => is_success, "body" => body}
          rescue
            _ ->
              Logger.error("Error decode body from handle_response")
              Logger.error("Error from url #{url} with response: #{inspect(response)}")

              %{"success" => false, "body" => body}
          end

        {:error, %HTTPoison.Error{id: nil, reason: {:tls_alert, {:unexpected_message, message}}}} ->
          Logger.error("Error from #{url}: #{message}")
          %{"success" => false, "reason" => message, "message" => err_msg}

        {:error, %HTTPoison.Error{reason: reason}} ->
          Logger.error("Error from #{url}: #{reason}")
          %{"success" => false, "reason" => reason, "message" => err_msg}
      end

    res
  end
end
