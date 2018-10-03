defmodule Elixir101.EexTest do
  use ExUnit.Case

  @tag :template
  test "Write template to pass the test" do
    # Assert the template file is evaluated with given data
    evaluated = EEx.eval_file("lib/templates/file1.html.eex", data: %{a: 1, b: 2})
    expected = "a = 1, b = 2"

    assert evaluated == expected
  end
end