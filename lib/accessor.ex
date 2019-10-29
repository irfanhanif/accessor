defmodule Accessor do
  @moduledoc """
  Accessor is an Elixir data structure manipulator wrapper
  """

  @doc """
  Update a value in a very deep nested map or list

      iex> Accessor.deep_put(%{a: %{"b" => %{c: 42}}}, [:a, "b", :c], 177)
      %{a: %{"b" => %{c: 177}}}
      
      iex> Accessor.deep_put(%{a: %{"b" => %{c: [42, 43, 44]}}}, [:a, "b", :c, 1], 177)
      %{a: %{"b" => %{c: [42, 177, 44]}}}
  """
  @spec deep_put(map | list, list, any) :: map | list
  defdelegate deep_put(data, keys, value), to: Accessor.DeepPut
  
  @doc ~S"""
  Map or list value validation. The function is very useful to check a value under a very deep and nested map or list.

  Evaluate these following functions:

      # This is the spec that will be used as reference to validate data within a map or list
      def spec do
        %{
          [:bio, "name", "first"] => [:is_it_string],
          [:bio, :age] => [:is_it_integer],
          [:position, 0] => [&is_it_software_engineer/2]
        }
      end

      # This is a custom validator function
      def is_it_software_engineer(keys, value) do
        if value == "software engineer" do
          :ok
        else
          {:error, "#{Enum.join(keys, ".")} is not a software engineer"}
        end
      end

  These are the results when you call the function:

      iex> data =
      ...>    %{
      ...>      bio: %{
      ...>        "name" => %{"first" => "irfan", "last" => "hanif"}, age: 22
      ...>      }, 
      ...>      position: ["software engineer", "junior architect"]
      ...>    }
      iex> Accessor.validation(data, spec)
      :ok

      iex> data =
      ...>    %{
      ...>      bio: %{
      ...>        "name" => %{"first" => 112548, "last" => "hanif"}, age: 22
      ...>      }, 
      ...>      position: ["software developer", "junior architect"]
      ...>    }
      iex> Accessor.validation(data, spec)
      {:error, ["bio.name.first is not a string", "position.0 is not a software engineer"]}

  This is a list of built-in validator function which you can use directly:

  - `:is_it_string` to check whether a value is in the form of string
  - `:is_it_integer` to check whether a value is in the form of integer
  - `:is_it_boolean` to check whether a value is in the form of boolean

  As you can see, it is possible for you to use your own custom validator. If you choose to make your own validator,
  the function must be capable of receiving two arguments `keys` and `value` and two returns possibilities: `:ok` or `{:error, error_message}`.
  At example above, `is_it_software_engineer/2` is a custom function validator.
  """
  @spec validation(map | list, map) :: :ok | {:error, [String.t]}
  defdelegate validation(data, spec), to: Accessor.Validation

  @doc """
  Get a value from a very deep nested map or list

      iex> Accessor.deep_get(%{bio: %{name: %{first: "irfan", last: "hanif"}, age: 22}, position: "software engineer"}, [:bio, :name, :last])
      "hanif"
      iex> Accessor.deep_get(%{bio: %{name: %{first: "irfan", last: "hanif"}, age: 22}, position: "software engineer"}, [:bio, :name, :middle], "power ranger")
      "power ranger"
  """
  @spec deep_get(map | list, list, any) :: any
  defdelegate deep_get(data, keys, default \\ nil), to: Accessor.DeepGet 
end
