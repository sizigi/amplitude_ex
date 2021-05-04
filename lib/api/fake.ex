defmodule Amplitude.API.Fake do
  defp priv(path) do
    priv =
      :code.priv_dir(:amplitude)
      |> to_string

    priv <> "/mock" <> path
  end

  defp load(path) do
    with {:ok, content} <- File.read(priv(path)),
         do: Poison.decode(content)
  end

  def api_track(_, _), do: {:ok, "success"}
  def api_identify(_, _), do: {:ok, "success"}
end
