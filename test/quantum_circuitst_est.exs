defmodule EdgeAI.QuantumCircuitsTest do
  use ExUnit.Case

  test "simula qubits" do
    assert EdgeAI.QuantumCircuits.simulate(5) == {:ok, "Simulated 5 qubits"}
  end
end
