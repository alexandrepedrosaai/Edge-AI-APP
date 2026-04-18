defmodule EdgeAI.TensorCoresTest do
  use ExUnit.Case

  test "multiplica matrizes" do
    assert {:ok, msg} = EdgeAI.TensorCores.multiply([[1,2]], [[3],[4]])
    assert String.contains?(msg, "Multiplied matrices")
  end
end
