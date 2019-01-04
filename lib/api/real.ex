defmodule Amplitude.API.Real do
  use HTTPoison.Base
  require Logger

  @track_api_url "https://api.amplitude.com/httpapi"
  @identify_api_url "https://api.amplitude.com/identify"

  defp track_api_url do
     Application.get_env(:amplitude, :api_host) || @track_api_url
  end

  defp identify_api_url, do: @identify_api_url

  defp api_key, do: Application.get_env(:amplitude, :api_key)

  defp json_header, do: ["Content-Type": "application/json"]

  def api_track(params) do
    case params |> Poison.encode() do
     {:ok, params} ->
       Task.start(fn() ->
         start()
         case get(track_api_url(), json_header(), [params: %{api_key: api_key(), event: params}]) do
           {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
             Logger.debug "Amplitude Track: #{body}"
           {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
             Logger.debug "Amplitude Track: #{body}"
           {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
             Logger.debug "Amplitude Track Failed: #{body}"
           {:error, %HTTPoison.Error{reason: reason}} ->
             Logger.debug "Amplitude Track Failed: #{reason}"
         end
       end)
       {:ok, "success"}
     {:error, message} ->
       {:error, "Unable to serialize params to JSON: #{inspect(message)}"}
   end
 end

  def api_identify(params) do
    case params |> Poison.encode() do
     {:ok, params} ->
       Task.start(fn() ->
         start()
         case get(identify_api_url(), json_header(), [params: %{api_key: api_key(), insert_id: UUID.uuid4(), identification: params}]) do
           {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
             Logger.debug "Amplitude Track: #{body}"
           {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
             Logger.debug "Amplitude Track: #{body}"
           {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
             Logger.debug "Amplitude Track Failed: #{body}"
           {:error, %HTTPoison.Error{reason: reason}} ->
             Logger.debug "Amplitude Track Failed: #{reason}"
         end
       end)
       {:ok, "success"}
     {:error, message} ->
       {:error, "Unable to serialize params to JSON: #{inspect(message)}"}
   end
  end

  # validate Poison response and strip out json value
  def verify_json({:ok, json}), do: json
  def verify_json({_, response}), do: "#{inspect(response)}"

  def process_request_headers(headers), do: headers++json_header()
end
