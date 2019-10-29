defmodule Accessor.Validation.Validator do
  @moduledoc false
  
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

  def is_it_boolean(keys, value) do
    if is_boolean(value) do
      :ok
    else
      {:error, "#{Enum.join(keys, ".")} is not a boolean"}
    end
  end
end
