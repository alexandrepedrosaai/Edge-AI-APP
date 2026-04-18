defmodule EdgeAI.ISAMatrix do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  def execute(:add, r1, r2), do: r1 + r2
  def execute(:mul, r1, r2), do: r1 * r2
  def execute(:nop, _r1, _r2), do: :ok
end
