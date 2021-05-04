defmodule Amplitude.API.Real do
  use HTTPoison.Base
  require Logger

  @track_api_url "https://api.amplitude.com/httpapi"
  @identify_api_url "https://api.amplitude.com/identify"

  defp track_api_url do
    Application.get_env(:amplitude, :track_api_url) || @track_api_url
  end

  defp identify_api_url do
    Application.get_env(:amplitude, :identify_api_url) || @identify_api_url
  end

  defp json_header, do: ["Content-Type": "application/json"]

  def api_track(params, opts \\ []) do
    api_key =
      Keyword.get_lazy(opts, :api_key, fn ->
        Application.get_env(:amplitude, :api_key)
      end)

    env_var = Application.get_env(:amplitude, :track_api_url)

    if env_var == "test" or api_key == nil do
      Logger.debug("Amplitude Track Skipped: test mode (#{env_var}), or nil api_key (#{api_key})")
      Amplitude.API.Fake.api_track(params, opts)
    else

      case params |> Poison.encode() do
        {:ok, params} ->
          Task.start(fn ->
            start()

            case get(track_api_url(), json_header(), params: %{api_key: api_key, event: params}) do
              {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                Logger.debug("Amplitude Track: #{body}")

              {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
                Logger.debug("Amplitude Track: #{body}")

              {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
                Logger.debug("Amplitude Track Failed: #{body}")

              {:error, %HTTPoison.Error{reason: reason}} ->
                Logger.debug("Amplitude Track Failed: #{reason}")
            end
          end)

          {:ok, "success"}

        {:error, message} ->
          {:error, "Unable to serialize params to JSON: #{inspect(message)}"}
      end
    end
  end

  def api_identify(params, opts \\ []) do
    api_key =
      Keyword.get_lazy(opts, :api_key, fn ->
        Application.get_env(:amplitude, :api_key)
      end)

    env_var = Application.get_env(:amplitude, :identify_api_url)

    if env_var == "test" or api_key == nil do
      Logger.debug("Amplitude Track Skipped: test mode (#{env_var}), or nil api_key (#{api_key})")
      Amplitude.API.Fake.api_identify(params, opts)
    else

      case params |> Poison.encode() do
        {:ok, params} ->
          Task.start(fn ->
            start()

            case get(identify_api_url(), json_header(),
                  params: %{api_key: api_key, insert_id: UUID.uuid4(), identification: params}
                ) do
              {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                Logger.debug("Amplitude Track: #{body}")

              {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
                Logger.debug("Amplitude Track: #{body}")

              {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
                Logger.debug("Amplitude Track Failed: #{body}")

              {:error, %HTTPoison.Error{reason: reason}} ->
                Logger.debug("Amplitude Track Failed: #{reason}")
            end
          end)

          {:ok, "success"}

        {:error, message} ->
          {:error, "Unable to serialize params to JSON: #{inspect(message)}"}
      end
    end
  end

  # validate Poison response and strip out json value
  def verify_json({:ok, json}), do: json
  def verify_json({_, response}), do: "#{inspect(response)}"

  def process_request_headers(headers), do: headers ++ json_header()
end
