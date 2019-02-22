defmodule Amplitude.API do
  defmacro __using__(_) do
    case Application.get_env(:amplitude, :track_api_url) do
      "test" <> _ ->
        quote do
          import Amplitude.API.Fake
        end

      _ ->
        quote do
          import Amplitude.API.Real
        end
    end

    case Application.get_env(:amplitude, :identify_api_url) do
      "test" <> _ ->
        quote do
          import Amplitude.API.Fake
        end

      _ ->
        quote do
          import Amplitude.API.Real
        end
    end
  end
end
