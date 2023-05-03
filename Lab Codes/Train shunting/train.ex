defmodule Train do
  @doc """
  Returns the first `n` elements of the train. If `n` is greater than the length
  of the train, the entire train is returned.
  """
  def take(_train, 0) do
    []
  end

  def take([head | tail], n) when n > 0 do
    [head | take(tail, n - 1)]
  end

  @doc """
  Drops the first `n` elements from the train and returns the remaining elements.
  If `n` is greater than the length of the train, an empty list is returned.
  """
  def drop(train, 0) do
    train
  end

  def drop([_head | tail], n) when n > 0 do
    drop(tail, n - 1)
  end

  @doc """
  Appends two trains together.
  """
  def append([], train2) do
    train2
  end

  def append([head | tail], train2) do
    [head | append(tail, train2)]
  end

  @doc """
  Checks if an element is a member of the train.
  """
  def member([], _y) do
    false
  end

  def member([y | _tail], y) do
    true
  end

  def member([_head | tail], y) do
    member(tail, y)
  end

  @doc """
  Returns the 1-based index of the first occurrence of an element in the train.
  Returns `nil` if the element is not found.
  """
  def position([y | _tail], y) do
    1
  end

  def position([_head | tail], y) do
    position(tail, y) + 1
  end

  @doc """
  Splits the train into two at the first occurrence of the given element. Returns
  a tuple containing the two resulting trains, neither containing the given
  element. If the element is not found in the train, returns a tuple containing
  an empty list and the original train.
  """
  def split([y | tail], y) do
    {[], tail}
  end

  def split([head | tail], y) do
    {tail, drop} = split(tail, y)
    {[head | tail], drop}
  end

  @doc """
  Simulates the movement of a train. Returns the tuple {k, remain, take} where remain
  and take are the wagons of train and k are the numbers of wagons remaining to have n
  wagons in the taken part.
  The wagons on the main track are in reverse order i.e. the first wagon in the list is
  in the leftmost position on the track. When you’re asked to move three wagons to another
  track you should dive the train into two segments; the segment that should remain and
  the three wagons (to the right i.e. in the end of the list) that should be moved.
  ## Example
    iex> Train.main([:a, :b, :c, :d], 3)
    {0, [:a], [:b, :c, :d]}
  """
  def main([], n) do
    {n, [], []}
  end

  def main([head | tail], n) do
    case main(tail, n) do
      {0, drop, take} ->
        {0, [head | drop], take}

      {n, drop, take} ->
        {n - 1, drop, [head | take]}
    end
  end
end
