defmodule CredoJenkins.MixProject do
  use Mix.Project

  def project do
    [
      app: :credo_jenkins,
      version: "0.1.1",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.3"},
      {:credo, "~> 1.6"}
    ]
  end
end
