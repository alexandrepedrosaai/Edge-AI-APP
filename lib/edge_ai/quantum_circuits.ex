defmodule EdgeAI.QuantumCircuits do
  @moduledoc "Simulações quânticas inspiradas"

  def child_spec(_args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [[]]}
    }
  end

  def start_link(_opts) do
    Task.start_link(fn -> :ok end)
  end

  
end
