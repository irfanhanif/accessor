defmodule Accessor.Validation do
  @no_error_detected_on_validation []
  @errors_accumulation_initialization []

  def validation(data, spec) when is_map(spec) do
    validation(data, Map.to_list(spec))
  end

  def validation(data, spec) when is_list(spec) do
    do_validation(data, spec)
  end

  defp do_validation(data, spec) do
    data
    |> iterate_trough_spec_and_accumulate_error_messages(spec)
    |> handle_validation_result()
  end

  defp iterate_trough_spec_and_accumulate_error_messages(data, spec) do
    Enum.reduce(spec, @errors_accumulation_initialization, 
      fn each_spec, all_errors_accumulation -> 
        get_and_accumulate_errors_on_each_spec(data, each_spec, all_errors_accumulation) 
      end)
  end

  defp get_and_accumulate_errors_on_each_spec(data, {path, validators}, all_errors_accumulation) do
    with {:ok, value} <- traverse_the_path_to_get_to_be_validated_value(data, path) do
      get_and_accumulate_errors_from_validators_validation(value, validators, path, all_errors_accumulation)
    else
      _ -> 
        concat_all_errors_with_the_error_of_the_validation(
          all_errors_accumulation,
          error_the_value_under_the_key_path_does_not_exist(path) 
        )
    end
  end

  defp traverse_the_path_to_get_to_be_validated_value(data, path) do
    Enum.reduce_while(path, data, 
      fn key, subtree -> 
        fetch_data_of_the_key(subtree, key)
      end)
    |> return_the_value_if_the_value_exist()
  end

  defp fetch_data_of_the_key(subtree, key) do
    case Map.fetch(subtree, key) do
      {:ok, value} -> continue_traversing_the_path_to_get_the_value(value)
      :error -> halt_traversing_the_path_and_return_error()
    end
  end

  defp continue_traversing_the_path_to_get_the_value(value) do
    {:cont, value}
  end

  defp halt_traversing_the_path_and_return_error do
    {:halt, :error_not_found}
  end

  defp return_the_value_if_the_value_exist(:error_not_found), do: :error
  defp return_the_value_if_the_value_exist(value), do: {:ok, value}

  defp get_and_accumulate_errors_from_validators_validation(value, validators, path, all_errors_accumulation) do
    Enum.reduce(validators, all_errors_accumulation, 
      fn validator, all_errors -> 
        concat_all_errors_with_the_error_of_the_validation(
          all_errors,
          get_error_of_the_validation(path, validator, value)
        )
      end)
  end

  defp error_the_value_under_the_key_path_does_not_exist(path) do
    "#{Enum.join(path, ".")} does not exist"
  end

  defp concat_all_errors_with_the_error_of_the_validation(all_errors, :no_error_detected) do
    all_errors
  end

  defp concat_all_errors_with_the_error_of_the_validation(all_errors, error_of_the_validation) do
    [error_of_the_validation | all_errors]
  end

  defp get_error_of_the_validation(path, validator, value) when is_atom(validator) do
    path
    |> do_validation_with_built_in_function(validator, value)
    |> parse_validation_result()
  end

  defp get_error_of_the_validation(path, validator, value) do
    path
    |> do_validation_with_custom_function(validator, value)
    |> parse_validation_result()
  end

  defp do_validation_with_built_in_function(path, validator, value) do
    apply(__MODULE__, validator, [path, value])
  end

  defp do_validation_with_custom_function(path, validator, value) do
    validator.(path, value)
  end

  defp parse_validation_result(:ok), do: :no_error_detected
  defp parse_validation_result({:error, error_message}), do: error_message

  defp handle_validation_result(@no_error_detected_on_validation), do: :ok
  defp handle_validation_result(accumulated_errors), do: {:error, accumulated_errors}

  def is_it_string(keys, value) do
    if is_binary(value) do
      :ok
    else
      {:error, "#{Enum.join(keys, ".")} is not a string"}
    end
  end

  def is_it_integer(keys, value) do
    if is_integer(value) do
      :ok
    else
      {:error, "#{Enum.join(keys, ".")} is not an integer"}
    end
  end
end
