Code.require_file("../ex_unit_extended.ex", __DIR__)

defmodule Accessor.ValidationTest do
  use ExUnit.Case
  use ExUnitExtended

  test "validation/2 ok" do
    given__(:dummy_data_1)
    |> when__(:deep_put_function_invoked_for_test_case_1)
    |> then__("The validation should", :returns_ok)
  end

  test "validation/2 all validation fails" do
    given__(:dummy_data_2)
    |> when__(:deep_put_function_invoked_for_test_case_1)
    |> then__("The error message should tell", :bio_name_first_is_not_a_string)
    |> then__("The error message should tell", :bio_age_is_not_and_integer)
    |> then__("The error message should tell", :position_0_is_not_a_software_engineer)
  end

  test "validation/2 there is unexist field" do
    given__(:dummy_data_3)
    |> when__(:deep_put_function_invoked_for_test_case_1)
    |> then__("The error message should tell", :bio_name_first_does_not_exist)
    |> then__("The error message should tell", :bio_age_does_not_exist)
    |> then__("The error message should tell", :position_0_does_not_exist)
  end

  test "validation/2 there is unexist field: trying to get value of list with non integer key" do
    given__(:dummy_data_4)
    |> when__(:deep_put_function_invoked_for_test_case_2)
    |> then__("The error message should tell", :bio_name_first_does_not_exist)
    |> then__("The error message should tell", :bio_age_does_not_exist)
    |> then__("The error message should tell", :position_primary_does_not_exist)
  end

  test "validation/2 there is unexist field: trying to get value of list with out of bound index" do
    given__(:dummy_data_4)
    |> when__(:deep_put_function_invoked_for_test_case_3)
    |> then__("The error message should tell", :bio_name_first_does_not_exist)
    |> then__("The error message should tell", :bio_age_does_not_exist)
    |> then__("The error message should tell", :position_2_does_not_exist)
  end

  defmodule Given do
    use ExUnit.Case
    use ExUnitExtended

    def dummy_data_1 do
      %{bio: %{"name" => %{"first" => "irfan", "last" => "hanif"}, age: 22}, position: ["software engineer", "junior architect"]}
    end

    def dummy_data_2 do
      %{bio: %{"name" => %{"first" => 112548, "last" => "hanif"}, age: "22"}, position: ["junior architect", "software engineer"]}
    end

    def dummy_data_3 do
      %{}
    end

    def dummy_data_4 do
      %{position: ["software engineer", "junior architect"]}
    end
  end

  defmodule When do
    use ExUnit.Case
    use ExUnitExtended

    def deep_put_function_invoked_for_test_case_1(case_data) do
      Accessor.validation(case_data, spec_test_case_1())
    end

    defp spec_test_case_1 do
      %{
        [:bio, "name", "first"] => [:is_it_string],
        [:bio, :age] => [:is_it_integer],
        [:position, 0] => [&is_it_software_engineer/2]
      }
    end

    def deep_put_function_invoked_for_test_case_2(case_data) do
      Accessor.validation(case_data, spec_test_case_2())
    end

    defp spec_test_case_2 do
      %{
        [:bio, "name", "first"] => [:is_it_string],
        [:bio, :age] => [:is_it_integer],
        [:position, :primary] => [&is_it_software_engineer/2]
      }
    end

    def deep_put_function_invoked_for_test_case_3(case_data) do
      Accessor.validation(case_data, spec_test_case_3())
    end

    defp spec_test_case_3 do
      %{
        [:bio, "name", "first"] => [:is_it_string],
        [:bio, :age] => [:is_it_integer],
        [:position, 2] => [&is_it_software_engineer/2]
      }
    end

    defp is_it_software_engineer(keys, value) do
      if value == "software engineer" do
        :ok
      else
        {:error, "#{Enum.join(keys, ".")} is not a software engineer"}
      end
    end
  end

  defmodule Then do
    use ExUnit.Case
    use ExUnitExtended

    def returns_ok(result, error_message) do
      test_assert(expected: :ok, actual: result, error_message: error_message)
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

    def position_0_is_not_a_software_engineer({:error, err}, error_message) do
      test_assert_member(
        expected: "position.0 is not a software engineer",
        list: err,
        error_message: error_message
      )
    end

    def bio_name_first_does_not_exist({:error, err}, error_message) do
      test_assert_member(
        expected: "bio.name.first does not exist",
        list: err,
        error_message: error_message
      )
    end

    def bio_age_does_not_exist({:error, err}, error_message) do
      test_assert_member(
        expected: "bio.age does not exist",
        list: err,
        error_message: error_message
      )
    end

    def position_0_does_not_exist({:error, err}, error_message) do
      test_assert_member(
        expected: "position.0 does not exist",
        list: err,
        error_message: error_message
      )
    end

    def position_primary_does_not_exist({:error, err}, error_message) do
      test_assert_member(
        expected: "position.primary does not exist",
        list: err,
        error_message: error_message
      )
    end

    def position_2_does_not_exist({:error, err}, error_message) do
      test_assert_member(
        expected: "position.2 does not exist",
        list: err,
        error_message: error_message
      )
    end
  end
end
