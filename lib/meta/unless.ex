defmodule Meta.Unless do
  defmacro unless(expression, do: block) do
    quote do
      if !unquote(expression), do: unquote(block)
    end
  end

  defmacro unless(expression, do: then, else: else_block) do
    quote do
      if !unquote(expression) do
        unquote(then)
      else
        unquote(else_block)
      end
    end
  end
end
