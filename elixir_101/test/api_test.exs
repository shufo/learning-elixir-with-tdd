defmodule Elixir101.ApiTest do
  use ExUnit.Case
  alias Elixir101.API

  @tag :api
  @tag :lib
  test "Write API module and request function to work with external JSON API" do
    # To work with external API and JSON, use HTTPoison and Poison.

    # Assert the given url is requested and returns parsed json
    url = ~s(http://www.fakeresponse.com/api/?data={"Hello":"World"})
    result = API.request(url)
    expected = %{"Hello" => "World"}

    assert result == expected

    :timer.sleep(2000)

    # Assert the given url is requested and returns parsed json
    url = ~s(http://www.fakeresponse.com/api/?data={"Foo":"Bar"})
    result = API.request(url)
    expected = %{"Foo" => "Bar"}

    assert result == expected

    # Assert the given url without sleep time returns rate limit error
    url = ~s(http://www.fakeresponse.com/api/?data={"Foo":"Bar"})
    result = API.request(url)
    expected = "Rate Limit exceeded!"

    assert result == expected
  end
end
