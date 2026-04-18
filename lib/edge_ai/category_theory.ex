defmodule EdgeAI.CategoryTheory do
  @moduledoc "Abstrações matemáticas com Category Theory"
  def child_spec(_args) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, [[]]}}
  end
  def start_link(_opts) do
    Task.start_link(fn -> :ok end)
  end
  def compose(f, g, x) do
    g.(f.(x))
  end
end
