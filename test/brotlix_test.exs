defmodule BrotlixTest do
  use ExUnit.Case
  doctest Brotlix

  @hello_world_br <<139, 8, 128, 123, 34, 104, 101, 108, 108, 111, 34, 58, 32, 34, 119, 111, 114,
                    108, 100, 34, 125, 3>>
  @hello_world ~s({"hello": "world"})

  test "Decompress" do
    assert Brotlix.decompress(@hello_world_br) == {:ok, @hello_world}
  end

  test "Decompress with max output size" do
    assert Brotlix.decompress(@hello_world_br, 10 * 1024 * 1024) ==
             {:ok, @hello_world}
  end

  test "Decompress with max output size reached" do
    assert Brotlix.decompress(@hello_world_br, 2) ==
             {:error, "payload exceeds maximum allowed size"}
  end
end
