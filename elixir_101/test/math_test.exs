defmodule Elixir101.MathTest do
  use ExUnit.Case
  alias Elixir101.Math

  @tag :basis
  test "Write Math module and sum function to pass the below code" do
    # Assert the inputs are summed up
    input = [1, 2, 3, 4, 5, 6]
    expected = 21

    assert Math.sum(input) == expected

    # Assert the inputs are summed up
    input = 1..100
    expected = 5050

    assert Math.sum(input) == expected
  end
end