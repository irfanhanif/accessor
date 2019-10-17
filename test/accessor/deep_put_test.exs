Code.require_file("../ex_unit_extended.ex", __DIR__)

defmodule Accessor.DeepPutTest do
  use ExUnit.Case
  use ExUnitExtended

  test "deep_put/3 update a value of map in deep nested mixed type data" do
    given__(:dummy_data_1)
    |> when__(:deep_put_function_invoked_for_test_case_1)
    |> then__("It should matched", :output_of_test_case_1)
  end

  test "deep_put/3 update a value of list in deep nested mixed type data" do
    given__(:dummy_data_2)
    |> when__(:deep_put_function_invoked_for_test_case_2)
    |> then__("It should matched", :output_of_test_case_2)
  end

  test "deep_put/3 update a value of keyword list in deep nested mixed type data" do
    given__(:dummy_data_3)
    |> when__(:deep_put_function_invoked_for_test_case_3)
    |> then__("It should matched", :output_of_test_case_3)
  end

  test "deep_put/3 the end of the target key is not exist" do
    given__(:dummy_data_1)
    |> when__(:deep_put_function_invoked_for_test_case_4)
    |> then__("It should raise error as the", :output_of_test_case_4)
  end

  defmodule Given do
    use ExUnit.Case
    use ExUnitExtended

    def dummy_data_1 do
      %{bio: %{name: %{first: "irfan", last: "hanif"}, age: 22}, position: "software engineer"}
    end

    def dummy_data_2 do
      %{bio: %{name: %{first: "irfan", last: "hanif"}, age: 22}, position: ["software engineer", "junior architect"]}
    end

    def dummy_data_3 do
      %{bio: %{name: %{first: "irfan", last: "hanif"}, age: 22}, 
        position: [primary: "software engineer", secondary: "junior architect"]}
    end
  end

  defmodule When do
    use ExUnit.Case
    use ExUnitExtended

    def deep_put_function_invoked_for_test_case_1(case_data) do
      Accessor.deep_put(case_data, [:bio, :name, :last], "apple")
    end

    def deep_put_function_invoked_for_test_case_2(case_data) do
      Accessor.deep_put(case_data, [:position, 1], "engineering manager")
    end

    def deep_put_function_invoked_for_test_case_3(case_data) do
      Accessor.deep_put(case_data, [:position, :secondary], "engineering manager")
    end

    def deep_put_function_invoked_for_test_case_4(case_data) do
      fn -> Accessor.deep_put(case_data, [:bio, :age, :unexist_key], "something") end
    end
  end

  defmodule Then do
    use ExUnit.Case
    use ExUnitExtended

    def output_of_test_case_1(result, error_message) do
      test_assert(expected: expected_output_of_test_case_1(), actual: result, error_message: error_message)
    end

    def expected_output_of_test_case_1 do
      %{bio: %{name: %{first: "irfan", last: "apple"}, age: 22}, position: "software engineer"}
    end

    def output_of_test_case_2(result, error_message) do
      test_assert(expected: expected_output_of_test_case_2(), actual: result, error_message: error_message)
    end

    def expected_output_of_test_case_2 do
      %{bio: %{name: %{first: "irfan", last: "hanif"}, age: 22}, position: ["software engineer", "engineering manager"]}
    end

    def output_of_test_case_3(result, error_message) do
      test_assert(expected: expected_output_of_test_case_3(), actual: result, error_message: error_message)
    end

    def expected_output_of_test_case_3 do
      %{bio: %{name: %{first: "irfan", last: "hanif"}, age: 22}, 
      position: [secondary: "engineering manager", primary: "software engineer"]}
    end

    def output_of_test_case_4(to_be_executed_deep_put, _error_message) do
      assert_raise Accessor.DeepPut.Error, "the value of target key :unexist_key is bad", to_be_executed_deep_put
    end
  end
end
