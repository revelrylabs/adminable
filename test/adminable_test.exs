defmodule AdminableTest do
  use ExUnit.Case
  doctest Adminable

  test "greets the world" do
    assert Adminable.hello() == :world
  end
end
