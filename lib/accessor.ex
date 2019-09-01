defmodule Accessor do
  defdelegate deep_put(data, keys, value), to: Accessor.DeepPut
  defdelegate validation(data, spec), to: Accessor.Validation
end
