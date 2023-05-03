defmodule Philosopher do
  def sleep(0) do
    :ok
  end

  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

  def start(hunger, right, left, name, ctrl) do
    spawn_link(fn -> dream(hunger, right, left, name, ctrl) end)
  end

  def dream(hunger, right, left, name, ctrl) do
    IO.puts("#{name} started dreaming")
    sleep(300)
    eat(hunger, right, left, name, ctrl)
    #eat_async(hunger, right, left, name, ctrl)
  end

  def eat(0, right, left, name, ctrl) do
    IO.puts("#{name} is done eating")
    send(ctrl, :done)
  end

  def eat(hunger, right, left, name, ctrl) do
    leftChopstick = Chopstick.request(left, :rand.uniform(100))
    #sleep(100)
    rightChopstick = Chopstick.request(right, :rand.uniform(100))
    case leftChopstick do
      :no ->
        IO.puts("#{name} didn't receive the left chopstick")
        Chopstick.return(left)
        sleep(200) #back-off timer the lower the value the more aggressive
        dream(hunger, right, left, name, ctrl)
      :ok ->
        IO.puts("#{name} received the left chopstick!")
        case rightChopstick do
          :no ->
            Chopstick.return(left)
            Chopstick.return(right)
            IO.puts("#{name} didn't receive the right chopstick")
            dream(hunger, right, left, name, ctrl)
          :ok ->
            IO.puts("#{name} received the right chopstick!")
            IO.puts("#{name} started eating")
            sleep(200)
            Chopstick.return(left)
            Chopstick.return(right)
            dream(hunger - 1, right, left, name, ctrl)
        end
    end
  end

  def eat_async(0, right, left, name, ctrl) do
    IO.puts("#{name} is done eating")
    send(ctrl, :done)
  end

  def eat_async(hunger, right, left, name, ctrl) do
    leftChopstick = Chopstick.request(left, :rand.uniform(100))
    #sleep(100)
    rightChopstick = Chopstick.request(right, :rand.uniform(100))
    if leftChopstick == :ok && rightChopstick == :ok do
      IO.puts("#{name} received both chopsticks!")
      IO.puts("#{name} started eating")
      sleep(100)
      Chopstick.return(left)
      Chopstick.return(right)
      dream(hunger - 1, right, left, name, ctrl)
    else
      IO.puts("#{name} could not get chopsticks")
      Chopstick.return(left)
      Chopstick.return(right)
      sleep(200) #back-off timer the lower the value the more aggressive
      dream(hunger, right, left, name, ctrl)
    end
  end

end
