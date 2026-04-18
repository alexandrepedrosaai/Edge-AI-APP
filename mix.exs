defmodule EdgeAI.MixProject do
  use Mix.Project

  def project do
    [
      app: :edge_ai_app,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases(),
      config_path: "config/configure.exs"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {EdgeAI.Application, []}
    ]
  end

  defp deps do
    [
      {:nx, "~> 0.6"},          # NumPy-like tensor ops em Elixir
      {:axon, "~> 0.6"},        # Deep learning em Elixir
      {:exqlite, "~> 0.13"},    # Banco leve para DAGs/Blockchain
      {:quantum, "~> 3.5"},     # Scheduler para simulações concorrentes
      {:flow, "~> 1.2"},        # Paralelismo de dados
      {:libcluster, "~> 3.3"}   # Clustering distribuído
    ]
  end

  defp releases do
    [
      edge_ai_app: [
        include_executables_for: [:unix],
        steps: [:assemble, :tar],
        strip_beams: true
      ]
    ]
  end
end
