defmodule EdgeAI.ISAMatrix do
  @moduledoc """
  Instruções ISA para matrizes.
  """
  def child_spec(_args) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, [[]]}}
  end
  def start_link(_opts) do
    Task.start_link(fn -> :ok end)
  end
  def execute(:add, a, b), do: a + b
  def execute(:mul, a, b), do: a * b
  def execute(:nop, _a, _b), do: :ok
end
