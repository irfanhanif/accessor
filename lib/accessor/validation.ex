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
    data
    |> fetch_to_be_validated_value_from_data(path)
    |> get_and_accumulate_errors_from_validators_validation(validators, path, all_errors_accumulation)
  end

  defp fetch_to_be_validated_value_from_data(data, path) do
    Enum.reduce(path, data, fn key, subtree -> Map.fetch!(subtree, key) end)
  end

  defp get_and_accumulate_errors_from_validators_validation(value, validators, path, all_errors_accumulation) do
    Enum.reduce(validators, all_errors_accumulation, 
      fn validator, all_errors -> 
        concat_all_errors_with_the_error_of_the_validation(
          all_errors,
          get_error_of_the_validation(path, validator, value)
        )
      end)
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
      {:error, "the value of #{inspect(keys)} is not a string"}
    end
  end

  def is_it_integer(keys, value) do
    if is_integer(value) do
      :ok
    else
      {:error, "the value of #{inspect(keys)} is not an integer"}
    end
  end
end