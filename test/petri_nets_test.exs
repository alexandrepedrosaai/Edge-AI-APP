defmodule EdgeAI.PetriNetsTest do
  use ExUnit.Case

  test "verifica transições" do
    assert EdgeAI.PetriNets.verify([:t1, :t2]) == {:ok, "Verified 2 transitions"}
  end
end
