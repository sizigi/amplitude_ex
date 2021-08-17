defmodule Amplitude.Mixfile do
  use Mix.Project

  def project do
    [
      app: :amplitude,
      version: "0.3.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Supports the Track and Identiy Amplitude API",
      package: package()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger, :uuid, :elixir_uuid]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:elixir_uuid, ">= 1.2.0"},
      {:httpoison, ">= 1.5.0"},
      {:poison, ">= 3.1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Ben Yee", "Donald Plummer"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/squaretwo/amplitude_ex"
      }
    ]
  end
end
