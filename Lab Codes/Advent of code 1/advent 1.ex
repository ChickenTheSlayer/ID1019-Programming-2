defmodule Day1 do
  def getInput(path) do
    txt = File.read!(path)
    readable = String.split(txt,"\r\n")
    list = create_list(readable, 0, [])
  end

  def create_list([], acc, sum) do [acc | sum] end
  def create_list([head | tail], acc, sum) do
    case head do
      "" -> [acc | create_list(tail, 0, sum)]
      _ ->
      {head, _} = Integer.parse(head)
      create_list(tail, acc + head, sum)
    end
  end

  def topthree(path, n) do
    list = getInput(path)
    fin = Enum.sort(list, :desc)
    three =Enum.take(fin, 3)
    Enum.reduce(three,0, fn x, acc-> x + acc end)
  end
end
