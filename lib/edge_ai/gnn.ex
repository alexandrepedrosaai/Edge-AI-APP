defmodule EdgeAI.GNN do
  @moduledoc "Graph Neural Network simplificada"

  def run(graph) do
    nodes = length(graph)
    {:ok, "Processed #{nodes} nodes"}
  end
end
