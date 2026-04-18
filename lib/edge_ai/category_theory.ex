defmodule EdgeAI.CategoryTheory do
  @moduledoc "Abstrações matemáticas com Category Theory"

  def compose(f, g, x) do
    g.(f.(x))
  end
end
