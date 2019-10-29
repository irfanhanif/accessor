defmodule Accessor.DeepPut do
  @moduledoc false

  defmodule Error do
    @moduledoc false
    defexception message: "deep_put error"
  end

  def deep_put(tree_of_data, list_of_target_keys, value) do
    if list_of_target_keys_empty?(list_of_target_keys) do
      value
    else
      [current_key | list_of_next_target_keys] = list_of_target_keys
      jump_and_update_the_next_subtree(tree_of_data, current_key, list_of_next_target_keys, value)
    end
  end

  defp list_of_target_keys_empty?(list_of_target_keys) do
    Enum.empty?(list_of_target_keys)
  end

  defp jump_and_update_the_next_subtree(
    tree_of_data, 
    current_key, 
    list_of_next_target_keys,
    value
  ) when is_map(tree_of_data) do
    tree_under_current_key = Map.fetch!(tree_of_data, current_key)
    Map.put(tree_of_data, current_key, deep_put(tree_under_current_key, list_of_next_target_keys, value))
  end

  defp jump_and_update_the_next_subtree(
    tree_of_data, 
    current_key, 
    list_of_next_target_keys,
    value
  ) when is_list(tree_of_data) do
    if Keyword.keyword?(tree_of_data) do
      jump_and_update_the_next_keyword_type_subtree(tree_of_data, current_key, list_of_next_target_keys, value)
    else
      jump_and_update_the_next_list_type_subtree(tree_of_data, current_key, list_of_next_target_keys, value)
    end
  end

  defp jump_and_update_the_next_subtree(_tree_of_data, current_key, _list_of_next_target_keys, _value) do
    raise Accessor.DeepPut.Error, message: "the value of target key #{inspect(current_key)} is bad"
  end

  defp jump_and_update_the_next_keyword_type_subtree(tree_of_data, current_key, list_of_next_target_keys, value) do
    tree_under_current_key = Keyword.fetch!(tree_of_data, current_key)
    Keyword.replace!(tree_of_data, current_key, deep_put(tree_under_current_key, list_of_next_target_keys, value))
  end

  defp jump_and_update_the_next_list_type_subtree(tree_of_data, current_key, list_of_next_target_keys, value) do
    tree_under_current_key = Enum.fetch!(tree_of_data, current_key)
      List.replace_at(tree_of_data, current_key, deep_put(tree_under_current_key, list_of_next_target_keys, value))
  end
end
