defmodule Hanoi do

  def test do
    hanoi(10, :a, :b, :c)
  end

  def hanoi(0, _, _, _) do [] end

  def hanoi(n, start, mid, finish) do
    hanoi(n-1, start, finish, mid) ++
    [{:move, start, finish}] ++
    hanoi(n-1, mid, start, finish)
  end
end
