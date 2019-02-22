# Amplitude_ex

An Elixir client for the Amplitude HTTP API

## Installation

  1. Add `amplitude` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:amplitude, "~> 0.2.0"}]
  end
  ```

## Usage

  1. Track events with the `Amplitude.track/4` function:

  ```elixir
  iex> Amplitude.track("LOGIN_SUCCESS", "janedoe_123", %{"ip" => "127.0.0.1"}, %{"cohort" => "Test A"}, api_key: "<your_api_key>")
  {:ok, "success"}
  ```

  See [Amplitude track event parameters](https://amplitude.zendesk.com/hc/en-us/articles/204771828#keys-for-the-event-argument) for more details on supported params to track.


  2. Identify users with the `Amplitude.identify/3` function:

  ```elixir
  iex> Amplitude.identify("janedoe_123", %{"gender" =>"female"}, %{"country" => "Canada"}, api_key: "<your_api_key>")
  {:ok, "success"}
  ```

  See [Amplitude identify parameters](https://amplitude.zendesk.com/hc/en-us/articles/205406617-Identify-API-Modify-User-Properties#keys-for-the-identification-argument)
