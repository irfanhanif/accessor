defmodule Accessor.DeepGet do
  @moduledoc false

  def deep_get(tree_of_data, list_of_keys, default \\ nil) do
    iterate_trough_list_of_keys_to_get_data(tree_of_data, list_of_keys, default)
  end

  defp iterate_trough_list_of_keys_to_get_data(tree_of_data, list_of_keys, default) do
    Enum.reduce_while(list_of_keys, tree_of_data, 
      fn key, subtree -> fetch_value_under_key(subtree, key) end)
    |> handle_result(default)
  end

  defp handle_result(:error_not_found, default), do: default
  defp handle_result(value, _default), do: value

  defp fetch_value_under_key(subtree, key) when is_map(subtree) do
    case Map.fetch(subtree, key) do
      :error -> halt_traversing_the_path_and_return_error()
      {:ok, value} -> continue_traversing_the_path_to_get_the_value(value)
    end
  end

  defp fetch_value_under_key(subtree, index) when is_list(subtree) and is_integer(index) do
    case Enum.at(subtree, index) do
      nil -> {:halt, :error_not_found}
      value -> {:cont, value}
    end
  end

  defp halt_traversing_the_path_and_return_error do
    {:halt, :error_not_found}
  end

  defp continue_traversing_the_path_to_get_the_value(value) do
    {:cont, value}
  end
end
