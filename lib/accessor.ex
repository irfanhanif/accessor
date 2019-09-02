defmodule Accessor do
  defdelegate deep_put(data, keys, value), to: Accessor.DeepPut
  defdelegate validation(data, spec), to: Accessor.Validation
  defdelegate deep_get(data, keys, default \\ nil), to: Accessor.DeepGet 
end
