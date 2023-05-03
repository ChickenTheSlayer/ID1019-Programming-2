defmodule Moves do
  @moduledoc """
  This module contains functions that represent moves on a train.
  To execute a sequence of moves on a train, call the `sequence/2` function.
  Each move is represented as a tuple of the form `{track, n}`, where `track`
  is either `:one` or `:two`, and `n` is an integer representing the number of wagons to move.
  The current state of the train is represented as a tuple of the form
  `{main, one, two}`, where `main` is a list of wagons on the main track,
  `one` is a list of wagons on track one, and `two` is a list of wagons on track two.
  """

  # Moves zero wagons. Returns the same state.
  def single({_track, 0}, state) do
    state
  end

  # Move `n` rightmost wagons from the main track to track one.
  def single({:one, n}, {main, one, two}) when n > 0 do
    {0, remain, wagons} = Train.main(main, n)
    {remain, Train.append(wagons, one), two}
  end

  # Move `n` leftmost wagons from track one to the main track.
  def single({:one, n}, {main, one, two}) when n < 0 do
    wagons = Train.take(one, -n)
    {Train.append(main, wagons), Train.drop(one, -n), two}
  end

  #Move `n` rightmost wagons from the main track to track two.
  def single({:two, n}, {main, one, two}) when n > 0 do
    {0, remain, wagons} = Train.main(main, n)
    {remain, one, Train.append(wagons, two)}
  end

  @doc """
  Move `n` leftmost wagons from track two to the main track.
  """
  def single({:two, n}, {main, one, two}) when n < 0 do
    wagons = Train.take(two, -n)
    {Train.append(main, wagons), one, Train.drop(two, -n)}
  end

  @doc """
  Executes a sequence of moves on a train starting from a given state.
  """
  def sequence([], state) do
    [state]
  end

  def sequence([head | tail], state) do
    [state | sequence(tail, single(head, state))]
  end
end
