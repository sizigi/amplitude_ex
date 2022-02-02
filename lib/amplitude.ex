defmodule Amplitude do
  use Amplitude.API

  @moduledoc """
  Functions for the Track and Indetify Amplitude APIs
  """

  # param keys for the Identify API minus user_id and user_properties
  @identify_keys ~w(
    device_id groups app_version
    platform os_name os_version device_brand device_manufacturer
    device_model carrier country region city dma
    language paying start_version
  )

  @doc """
  Track an event with specified properties

      iex> {:ok, response} = Amplitude.track("my_event", "janedoe_123", %{"ip" => "127.0.0.1"}, %{"cohort" => "Test A"})
      ...> response
      "success"
  """
  @spec track(String.t(), String.t(), map(), map(), map(), keyword()) ::
          {:ok, String.t()} | {:error, String.t()}
  def track(event_type, user_id, event_props \\ %{}, user_props \\ %{}, extra_props \\ %{}, opts \\ [])

  def track(event_type, user_id, event_props, user_props, extra_props, opts) do
    %{
      "event_type" => event_type,
      "user_id" => user_id,
      "event_properties" => event_props,
      "user_properties" => user_props
    }
    |> Map.merge(extra_props)
    |> api_track(opts)
  end

  @doc """
  Identify a user with custom user properties and/or Amplitude specified user properties

      iex> {:ok, response} = Amplitude.identify("janedoe_123", %{"gender" => "female", "email": "jdoe_123@example.com"}, %{"country" => "United States"})
      ...> response
      "success"
  """
  @spec track(String.t(), map(), map(), keyword()) :: {:ok, String.t()} | {:error, String.t()}
  def identify(user_id, user_props, identify_props \\ %{}, extra_props \\ %{}, opts \\ [])

  def identify(user_id, user_props, identify_props, opts) do
    identify_props
    |> Map.take(@identify_keys)
    |> Map.merge(%{"user_id" => user_id, "user_properties" => user_props})
    |> Map.merge(extra_props)
    |> api_identify(opts)
  end
end
