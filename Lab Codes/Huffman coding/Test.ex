defmodule Huffman do

  def sample do
  'the quick brown fox jumps over the lazy dog
  this is a sample text that we will use when we build
  up a table we will only handle lower case letters and
  no punctuation symbols the frequency will of course not
  represent english but it is probably not that far off'
  end

  #def sample() do 'foo' end
  def text() do
    'this is something that we should encode'
  end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = read("file.txt")
    seq = encode(text, encode)
    decode(seq, decode)
    |> to_string()
  end

  def bench() do
    file = text()
    t0 = :os.system_time(:millisecond)
    tree = tree(file)
    t1 = :os.system_time(:millisecond)
    tree_t = t1-t0
    t0 = :os.system_time(:millisecond)
    encode = encode_table(tree)
    t1 = :os.system_time(:millisecond)
    encode_t = t1-t0
    t0 = :os.system_time(:millisecond)
    seq = encode(file, encode)
    t1 = :os.system_time(:millisecond)
    seq_t = t1-t0
    t0 = :os.system_time(:millisecond)
    decode(seq, encode)
    t1 = :os.system_time(:millisecond)
    decode_t = t1-t0
    :io.format("File size ~w~nComprimized size ~w~nThe time it took to make a tree: ~w~nThe time it took to make encode table: ~w~nThe time it took to encode kallocain: ~w~nThe time it took to decode kallocain: ~w~n", [length(file),div(length(seq),8), tree_t, encode_t, seq_t,decode_t])
  end
  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def freq(sample) do
    freq(sample, [])
  end

  def freq([], freq) do
    freq
  end

  def freq([char | rest], freq) do
    freq(rest, update(char, freq))
  end

  def update(char, []) do [{char,1}] end

  def update(char, [head|tail]) do
    case head do
       {^char, nr} -> [{char,(nr+1)} | tail]
       {_,_} -> [ head | update(char, tail)]
    end
  end

  def huffman(freq) do
   freq = Enum.sort_by(freq, fn {_,x} -> x end)
   huffman_t(freq)
  end

  def huffman_t([{char,_}]) do char end
  def huffman_t([{char1,nr1}, {char2,nr2} | rest]) do
    huffman_t(insert({{char1,char2}, nr1+nr2}, rest))
  end

  def insert(char, []) do [char] end
  def insert({char, freq}, [{char2,freq2} | rest]) do
    case freq < freq2 do
      :true -> [{char, freq}, {char2,freq2} | rest]
      :false -> [{char2,freq2} | insert({char, freq},rest)]
    end
  end

  def encode_table(tree) do
    get_codes(tree,[])
  end

  def get_codes({left,right}, code) do
    left = get_codes((left), [0 | code])
    right = get_codes((right), [1 | code])
    left ++ right
  end

  def get_codes(char, code) do [{char, Enum.reverse(code)}] end

  def decode_table(tree) do
    encode_table(tree)
    #ID1019 KTH 2 / 7
    # To implement...
  end

  def encode(text, table) do
     lst = Enum.map(text, fn(x) -> table_lookup(table,x) end)
     together(lst)
  end

  def table_lookup([], _) do [] end
  def table_lookup([head|tail], arg) do
    case head do
      {^arg, list} -> list
      {_,_} -> table_lookup(tail,arg)
    end
  end
  def table_lookup(_,_) do nil end

  def together([]) do [] end
  def together([head|tail]) do head ++ together(tail) end

  def decode([], _) do
    []
  end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end
  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} ->
      {char,rest}
      nil ->
      decode_char(seq, n+1, table)
    end
  end

  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)
      case :unicode.characters_to_list(binary, :utf8) do
        {:incomplete, list, _} ->
          list
        list ->
          list
      end
  end
end