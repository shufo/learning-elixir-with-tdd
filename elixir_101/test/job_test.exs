defmodule Elixir101.JobTest do
  use ExUnit.Case
  alias Elixir101.Job

  @tag :task
  test "Write job module and async function to process the background task" do
    # Assert the background job is processed
    result = Job.async(fn -> 1 + 1 end)
    expected = 2

    assert result == expected

    # Assert the background job is processed
    result = Job.async(fn -> 2 * 3 end)
    expected = 6

    assert result == expected
  end
end
