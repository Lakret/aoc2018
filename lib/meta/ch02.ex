defmodule Meta.CH02 do
  # alias Meta.CH02; import CH02
  defmacro my_if(expr, do: if_block) do
    if(expr, do: if_block, else: nil)
  end

  defmacro my_if(expr, do: if_block, else: else_block) do
    quote do
      case unquote(expr) do
        result when result in [false, nil] -> unquote(else_block)
        _ -> unquote(if_block)
      end
    end
  end

  defmacro while(expression, do: block) do
    quote do
      try do
        for _ <- Stream.cycle([:ok]) do
          if unquote(expression) do
            unquote(block)
          else
            Meta.CH02.break()
          end
        end
      catch
        :break -> :ok
      end
    end
  end

  def break() do
    throw(:break)
  end

  def test_while() do
    pid = spawn(fn -> :timer.sleep(4000) end)

    while Process.alive?(pid) do
      IO.puts("Still alive")
      :timer.sleep(1000)
    end
  end

  def test_while_with_break() do
    spawn(fn ->
      while true do
        receive do
          :stop ->
            IO.puts("Stopping")
            break()

          message ->
            IO.puts("Got #{inspect(message)}")
        end
      end
    end)
  end

  # this will do all side-effects for `expression` twice -
  # every time it is unquoted! thus we need to use `bind_quoted`
  # instead
  defmacro log_bad(expression) do
    if Application.get_env(:debugger, :log_level) == :debug do
      quote do
        IO.puts("=====")
        IO.inspect(unquote(expression))
        IO.puts("=====")
        unquote(expression)
      end
    else
      expression
    end
  end

  defmacro log(expression) do
    if Application.get_env(:debugger, :log_level) == :debug do
      quote bind_quoted: [expression: expression] do
        IO.puts("=====")
        IO.inspect(expression)
        IO.puts("=====")
        expression
      end
    else
      expression
    end
  end

  def debug_on() do
    Application.put_env(:debugger, :log_level, :debug)
  end

  def debug_off() do
    Application.put_env(:debugger, :log_level, :prod)
  end
end
