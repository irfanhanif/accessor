defmodule ExUnitExtended do
  defmacro __using__(_) do
    quote do
      def given__(given_function_name) do
        apply(__MODULE__.Given, given_function_name, [])
      end

      def when__(data_from_given_statement, test_function_name) do
        apply(__MODULE__.When, test_function_name, [data_from_given_statement])
      end

      def then__(data_from_when_statement, message_prefix, assertion_function_name) do
        error_message = "#{message_prefix} #{Atom.to_string(assertion_function_name)}!"
        apply(__MODULE__.Then, assertion_function_name, [data_from_when_statement, error_message])
        data_from_when_statement
      end

      def test_assert(expected: expected, actual: actual, error_message: error_message) do
        assert(
          expected == actual,
          "#{error_message}\nExpected\t: #{inspect(expected)}\nActual\t: #{inspect(actual)}"
        )
      end

      def test_assert_member(expected: expected, list: list, error_message: error_message) do
        assert(
          Enum.member?(list, expected),
          "#{error_message}\nExpected Member\t: #{inspect(expected)}\nList\t\t: #{inspect(list)}"
        )
      end

      def test_assert_received(expected: expected, error_message: error_message) do
        assert_received(
          ^expected,
          "#{error_message} Expected to receive data: #{inspect(expected)}"
        )
      end

      def test_refute_received(expected: expected, error_message: error_message) do
        refute_received(
          ^expected,
          "#{error_message} Expected to NOT receive data: #{inspect(expected)}"
        )
      end
    end
  end
end
