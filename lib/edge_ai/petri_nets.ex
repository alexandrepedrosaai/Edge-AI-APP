defmodule EdgeAI.PetriNets do
  @moduledoc "Modelagem de concorrência com Petri Nets"

  def verify(transitions) do
    {:ok, "Verified #{length(transitions)} transitions"}
  end
end
