defmodule Accessor.Validation.ValidatorTest do
  use ExUnit.Case
  alias Accessor.Validation.Validator

  test "is_it_string/2" do
    assert Validator.is_it_string([:a, :b, :c], "this is a string") == :ok
    assert Validator.is_it_string([:a, :b, :c], 123) == {:error, "a.b.c is not a string"}
  end

  test "is_it_integer/2" do
    assert Validator.is_it_integer([:a, :b, :c], 123) == :ok
    assert Validator.is_it_integer([:a, :b, :c], "123") == {:error, "a.b.c is not an integer"}
  end

  test "is_it_boolean/2" do
    assert Validator.is_it_boolean([:a, :b, :c], true) == :ok
    assert Validator.is_it_boolean([:a, :b, :c], false) == :ok
    assert Validator.is_it_boolean([:a, :b, :c], "true") == {:error, "a.b.c is not a boolean"}
  end
end
