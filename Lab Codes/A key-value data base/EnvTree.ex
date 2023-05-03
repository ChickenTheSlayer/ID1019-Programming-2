defmodule EnvTree do
  def new(), do: nil

  # REMEMBER WE SORT BY KEY, NOT VALUE! :A < :a and :a < :aa
  # When empty we add the new pair
  def add(nil, key, value) do
    {:node, key, value, nil, nil}
  end

  # if the key already exists we replace it
  def add({:node, key, _, left, right}, key, value) do
    {:node, key, value, left, right}
  end

  # return a tree that looks like the one we have but where the left branch has been updated
  def add({:node, k, v, left, right}, key, value) when key < k do
    {:node, k, v, add(left, key, value), right}
  end

  # same as above but we update the right branch when the new key is bigger
  def add({:node, k, v, left, right}, key, value) do
    {:node, k, v, left, add(right, key, value)}
  end

  # if key not found we return nil
  def lookup(nil, _), do: nil
  # we've found the key
  def lookup({:node, key, value, _, _}, key) do
    {key, value}
  end

  # if the key we're searching for is smaller than where we're at we go down left
  def lookup({:node, k, _, left, _}, key) when key < k do
    lookup(left, key)
  end

  # else we go down right
  def lookup({:node, _, _, _, right}, key) do
    lookup(right, key)
  end
  #if the tree is empty
  def remove(nil, _) do nil end
  def remove({:node, key, _, nil, right}, key) do right end
  def remove({:node, key, _, left, nil}, key) do left end
  def remove({:node, key, _, left, right}, key) do
    {key, value, rest} = leftmost(right)
    {:node, key, value, left, rest}
  end
  def remove({:node, k, v, left, right}, key) when key < k do
    {:node, k, v, remove(left, key), right}
  end
  def remove({:node, k, v, left, right}, key) do
    {:node, k, v, left, remove(right, key)}
  end

  #if the right branch doesn't have a left branch we can simply return
  def leftmost({:node, key, value, nil, rest}) do {key, value, rest} end
  def leftmost({:node, k, v, left, right}) do
    {key, value, rest} = leftmost(left)
    {key, value, {:node, k, v, rest, right}}
  end
end
