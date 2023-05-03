defmodule Expression do
  @type literal() ::
          {:num, number()}
          | {:var, atom()}
          | {:q, number(), number()}

  @type expr() ::
          {:add, expr(), expr()}
          | {:sub, expr(), expr()}
          | {:mul, expr(), expr()}
          | {:div, expr(), expr()}
          | literal()

  def test do

    exprTest = {:add, {:mul, {:num, 2}, {:var, :y}}, {:sub, {:q, 3, 6}, {:q, 2, 12}}}
    env = %{x: 1, y: 2, z: 3}
    simplify(eval(exprTest, env))
  end

  def eval({:num, n}, _) do
    n
  end

  def eval({:var, v}, env) do
    Map.get(env, v)
  end

  def eval({:add, e1, e2}, env) do
    add(eval(e1, env), eval(e2, env))
  end

  def eval({:sub, e1, e2}, env) do
    sub(eval(e1, env), eval(e2, env))
  end

  def eval({:mul, e1, e2}, env) do
    mul(eval(e1, env), eval(e2, env))
  end

  def eval({:div, e1, e2}, env) do
    divi(eval(e1, env), eval(e2, env))
  end

  def eval({:q, e1, e2}, _) do
    {:q, e1, e2}
  end

  def add({:q, e1, e2}, {:q, e3, e4}) do
    {:q, e1 * e4 + e3 * e2, e2 * e4}
  end

  def add({:q, e1, e2}, e3) do
    {:q, e1 + e3 * e2, e2}
  end

  def add(e1, {:q, e2, e3}) do
    {:q, e1 * e3 + e2, e3}
  end

  def add(e1, e2) do
    {:q, e1 + e2, 1}
  end

  def sub({:q, e1, e2}, {:q, e3, e4}) do
    {:q, e1 * e4 - e3 * e2, e2 * e4}
  end

  def sub({:q, e1, e2}, e3) do
    {:q, e1 - e3 * e2, e2}
  end

  def sub(e1, {:q, e2, e3}) do
    {:q, e1 * e3 - e2, e3}
  end

  def sub(e1, e2) do
    {:q, e1 - e2, 1}
  end

  def mul({:q, e1, e2}, {:q, e3, e4}) do
    {:q, e1 * e3, e2 * e4}
  end

  def mul({:q, e1, e2}, e3) do
    {:q, e1 * e3, e2}
  end

  def mul(e1, {:q, e2, e3}) do
    {:q, e1 * e2, e3}
  end

  def mul(e1, e2) do
    {:q, e1 * e2, 1}
  end

  def divi({:q, e1, e2}, {:q, e3, e4}) do
    {:q, e1 * e4, e2 * e3}
  end

  def divi({:q, e1, e2}, e3) do
    {:q, e1, e2 * e3}
  end

  def divi(e1, {:q, e2, e3}) do
    {:q, e1 * e3, e2}
  end

  def divi(e1, e2) do
    {:q, e1, e2}
  end

  def simplify({:q, e1, e2}) do
    gcd = Integer.gcd(e1, e2)

    if(gcd == 1) do
      pprint({:q, e1, e2})
    else
      pprint({:q, e1 / gcd, e2 / gcd})
    end
  end

  def pprint({:num, e}) do
    "#{trunc(e)}"
  end

  def pprint({:q, e1, 1.0}) do
    "#{trunc(e1)}"
  end

  def pprint({:q, e1, e2}) do
    "#{trunc(e1)}/#{trunc(e2)}"
  end
end