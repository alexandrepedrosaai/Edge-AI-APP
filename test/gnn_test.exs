defmodule EdgeAI.GNNTest do
  use ExUnit.Case

  test "processa grafo" do
    assert EdgeAI.GNN.run([:a, :b, :c]) == {:ok, "Processed 3 nodes"}
  end
end
