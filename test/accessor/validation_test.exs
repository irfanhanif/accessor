Code.require_file("../ex_unit_extended.ex", __DIR__)

defmodule Accessor.ValidationTest do
  use ExUnit.Case
  use ExUnitExtended

  test "validation/2 ok" do
    given__(:dummy_data_1)
    |> when__(:deep_put_function_invoked_for_test_case_1)
    |> then__("The validation should", :returns_ok)
  end

  def dummy_data_1 do
    %{bio: %{"name" => %{"first" => "irfan", "last" => "hanif"}, age: 22}, position: "software engineer"}
  end

  def deep_put_function_invoked_for_test_case_1(case_data) do
    Accessor.validation(case_data, spec_test_case_1())
  end

  def spec_test_case_1 do
    %{
      [:bio, "name", "first"] => [:is_it_string],
      [:bio, :age] => [:is_it_integer],
      [:position] => [&is_it_software_engineer/2]
    }
  end

  def is_it_software_engineer(keys, value) do
    if value == "software engineer" do
      :ok
    else
      {:error, "#{Enum.join(keys, ".")} is not a software engineer"}
    end
  end

  def returns_ok(result, error_message) do
    test_assert(expected: :ok, actual: result, error_message: error_message)
  end

  test "validation/2 all validation fails" do
    given__(:dummy_data_2)
    |> when__(:deep_put_function_invoked_for_test_case_1)
    |> then__("The error message should tell", :bio_name_first_is_not_a_string)
    |> then__("The error message should tell", :bio_age_is_not_and_integer)
    |> then__("The error message should tell", :position_is_not_a_software_engineer)
  end

  def dummy_data_2 do
    %{bio: %{"name" => %{"first" => 112548, "last" => "hanif"}, age: "22"}, position: "junior architect"}
  end

  def bio_name_first_is_not_a_string({:error, err}, error_message) do
    test_assert_member(
      expected: "bio.name.first is not a string",
      list: err,
      error_message: error_message
    )
  end

  def bio_age_is_not_and_integer({:error, err}, error_message) do
    test_assert_member(
      expected: "bio.age is not an integer",
      list: err,
      error_message: error_message
    )
  end

  def position_is_not_a_software_engineer({:error, err}, error_message) do
    test_assert_member(
      expected: "position is not a software engineer",
      list: err,
      error_message: error_message
    )
  end

  # test "validation/2 there is unexist field" do
  #   given__(:dummy_data_3)
  #   |> when__(:deep_put_function_invoked_for_test_case_1)
  #   |> then__("The error message should tell", :bio_name_first_is_not_a_string)
  #   |> then__("The error message should tell", :bio_age_is_not_and_integer)
  #   |> then__("The error message should tell", :position_is_not_a_software_engineer)
  # end

  # def dummy_data_3 do
  #   %{bio: %{"name" => %{"first" => 112548, "last" => "hanif"}, age: "22"}, position: "junior architect"}
  # end
end
