defmodule Accessor do
  defdelegate deep_put(data, keys, value), to: Accessor.DeepPut
end
