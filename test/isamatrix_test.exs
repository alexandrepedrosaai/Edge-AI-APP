defmodule EdgeAI.ISAMatrixTest do
  use ExUnit.Case

  test "executa soma" do
    assert EdgeAI.ISAMatrix.execute(:add, 2, 3) == 5
  end

  test "executa multiplicação" do
    assert EdgeAI.ISAMatrix.execute(:mul, 2, 3) == 6
  end

  test "executa nop" do
    assert EdgeAI.ISAMatrix.execute(:nop, 0, 0) == :ok
  end
end
