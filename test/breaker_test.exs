defmodule BreakerTest do
  use ExUnit.Case
  doctest Breaker

  test "greets the world" do
    assert Breaker.hello() == :world
  end
end
