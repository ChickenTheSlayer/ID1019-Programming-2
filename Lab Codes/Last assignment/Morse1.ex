defmodule Morse do

  def test1(), do: '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ...'
  def test2(), do: '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .----'

  #Fredrik
def test3(), do: '..-. .-. . -.. .-. .. -.- '

  def decode(signal) do
    table = morse()
    decode(signal, table, table)
  end

  def decode([], _, _) do  []  end
  def decode([?- | rest], {:node, _, left, _}, tree) do
    decode(rest, left, tree)
  end
  def decode([?. | rest], {:node, _, _, right}, tree) do
    decode(rest, right, tree)
  end
  def decode([?\s | rest], {:node, ascii, _, _}, tree) do
    [ascii | decode(rest, tree, tree)]
  end


########################################################################
  def fredrik(), do: 'fredrik'

  def encode(text) do
    table = encode_table()
    encode(text, table)
  end
  def encode([], _) do [] end
  def encode([char | rest], table) do
    {_, code} = List.keyfind(table, char, 0)
    code ++ ' ' ++ encode(rest, table)
  end

  ####################################################

  def encode_table() do
     tree = morse()
     Enum.sort(codes(tree, []))
     #sorts output of tree place them in alphabeticall order
  end

 def codes({:node, ascii, a, b}, sofar) do
  #lookup table of ASCII characters and morse code sequences

   left = codes(a, sofar ++ [ ?-])
   right = codes(b, sofar ++ [ ?.])
   [{ascii, sofar}] ++ left ++ right
   #node character and morse code.
 end
 def codes( ascii, code) do
   case ascii do
      nil ->    [ ]
      #in case of empty
      _   ->    [{ascii, code}]
   end
  end


  def morse() do
    {:node, :na,
      {:node, 116,
        {:node, 109,
          {:node, 111,
            {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
            {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
          {:node, 103,
            {:node, 113, nil, nil},
            {:node, 122,
              {:node, :na, {:node, 44, nil, nil}, nil},
              {:node, 55, nil, nil}}}},
        {:node, 110,
          {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
          {:node, 100,
            {:node, 120, nil, nil},
            {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
        {:node, 97,
          {:node, 119,
            {:node, 106,
              {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
              nil},
            {:node, 112,
              {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
              nil}},
          {:node, 114,
            {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
            {:node, 108, nil, nil}}},
        {:node, 105,
          {:node, 117,
            {:node, 32,
              {:node, 50, nil, nil},
              {:node, :na, nil, {:node, 63, nil, nil}}},
            {:node, 102, nil, nil}},
          {:node, 115,
            {:node, 118, {:node, 51, nil, nil}, nil},
            {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

end
