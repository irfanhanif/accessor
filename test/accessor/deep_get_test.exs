Code.require_file("../ex_unit_extended.ex", __DIR__)

defmodule Accessor.DeepGetTest do
  use ExUnit.Case
  use ExUnitExtended

  test "deep_get/3 get a value of map in deep nested mixed type data" do
    given__(:dummy_data_1)
    |> when__(:deep_get_function_invoked_for_test_case_1)
    |> then__("It should matched", :output_of_test_case_1)
  end

  def dummy_data_1 do
    [
      %{bio: %{name: %{first: "irfan", last: "hanif"}, age: 22}, position: "software engineer"},
      %{bio: %{name: %{first: "alan", last: "turing"}, age: 43}, position: "inventor"},
    ]
  end

  def deep_get_function_invoked_for_test_case_1(case_data) do
    Accessor.deep_get(case_data, [0, :bio, :name, :last])
  end

  def output_of_test_case_1(result, error_message) do
    test_assert(expected: "hanif", actual: result, error_message: error_message)
  end

  test "deep_get/3 get a value of map in deep nested mixed type data not found and use default" do
    given__(:dummy_data_1)
    |> when__(:deep_get_function_invoked_for_test_case_2)
    |> then__("It should matched", :output_of_test_case_2)
  end

  def deep_get_function_invoked_for_test_case_2(case_data) do
    Accessor.deep_get(case_data, [0, :bio, :name, :middle], "power ranger")
  end

  def output_of_test_case_2(result, error_message) do
    test_assert(expected: "power ranger", actual: result, error_message: error_message)
  end
end
