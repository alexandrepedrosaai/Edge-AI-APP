defmodule EdgeAI.CategoryTheoryTest do
  use ExUnit.Case

  test "compõe funções" do
    f = fn x -> x + 1 end
    g = fn x -> x * 2 end
    assert EdgeAI.CategoryTheory.compose(f, g, 3) == 8
  end
end
