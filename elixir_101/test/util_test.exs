defmodule Elixir101.UtilTest do
  use ExUnit.Case
  alias Elixir101.Util

  @tag :basis
  test "Write Utility module and split function to pass the below code" do
    # Assert the input string is splitted
    input = "Split me"
    expected = ["Split", "me"]

    assert Util.split(input) == expected

    # Assert the input string is splitted
    input = "foo bar"
    expected = ["foo", "bar"]

    assert Util.split(input) == expected
  end

  @tag :basis
  @tag :enum
  test "Write Utility module and multiply function to pass the below code" do
    # Assert the inputs are multiplied
    input = [1, 2, 3]
    expected = [2, 4, 6]

    assert Util.multiply(input, 2) == expected

    # Assert the inputs are multiplied
    input = [1, 2, 3]
    expected = [10, 20, 30]

    assert Util.multiply(input, 10) == expected
  end

  @tag :basis
  @tag :error
  test "Write utility module and multiply function to raise the Runtime Error when multiply number is negative" do
    # Assert the Runtime Error is raised if multiply number is a negative
    input = [1, 2, 3]
    expected_error = RuntimeError

    assert_raise expected_error, fn ->
      Util.multiply(input, -1)
    end
  end

  @tag :error
  test "Write utility module and multiply function to raise the custom error" do
    # Assert the StringCannotMultiplyError exception is raised when input is a string
    assert_raise StringCannotMultiplyError, fn ->
      Util.multiply("This is a fucking string", 2)
    end
  end

  @tag :enum
  test "Write Util module and prev function to pass the below code" do
    # Assert the function returns prev value specified in second args
    input = [1, 2, 3]
    expected = 1

    assert Util.prev_num(input, 2) == expected

    # Assert the function returns prev value specified in second args
    input = ["Bob", "Shuhei", "Alice"]
    expected = "Shuhei"

    assert Util.prev_num(input, "Alice") == expected

    # Assert the function returns nil if there is no value specified in args
    input = [1, 2, 3, 4, 5, 6]
    expected = nil

    assert Util.prev_num(input, 10) == expected
  end
end