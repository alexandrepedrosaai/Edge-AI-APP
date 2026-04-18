defmodule EdgeAI.Application do
  @moduledoc """
  Supervision tree para o Edge-AI-APP.
  Cada módulo (ISA, GNN, Quantum, Petri, Tensor, Category, Blockchain)
  é supervisionado como processo OTP, garantindo concorrência e resiliência.
  """

  @derive {Inspect, only: []}
  use Application

  def start(_type, _args) do
    children = [
      # Supervisores de cluster (se usar libcluster)
      {Cluster.Supervisor, [Application.get_env(:libcluster, :topologies), [name: EdgeAI.ClusterSupervisor]]},

      # Módulos principais
      {EdgeAI.ISAMatrix, []},
      {EdgeAI.GNN, []},
      {EdgeAI.QuantumCircuits, []},
      {EdgeAI.PetriNets, []},
      {EdgeAI.TensorCores, []},
      {EdgeAI.CategoryTheory, []},
      {EdgeAI.BlockchainDAGs, []}
    ]

    opts = [strategy: :one_for_one, name: EdgeAI.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
