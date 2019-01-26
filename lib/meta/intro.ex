defmodule Meta.Intro do
  @moduledoc """
  ## AST

  Types that are preserved as is in the AST:
  atoms, integers, floats, lists, strings,
  and any two-element tuples containing the former types

  ## Useful functions

  - `Code.eval_quoted` - evalutes quoted expression
  - `Macro.expand_once/2` - expands macros once

  ## Examples

      iex> ast = quote do
      ...>   unless 2 == 5, do: "entered block"
      ...> end
      {
        :unless,
        [context: Elixir, import: Kernel],
        [
          {:==, [context: Elixir, import: Kernel], [3, 5]},
          [do: "foo"]
        ]
      }

      iex> expanded_once = Macro.expand_once(ast, __ENV__)
      {
        :if,
        [context: Kernel, import: Kernel],
        [
          {:==, [context: Elixir, import: Kernel], [3, 5]},
          [do: nil, else: "foo"]
        ]
      }

      iex> fully_expanded = Macro.expand(expanded_once, __ENV__)
      {:case, [optimize_boolean: true],
        [
          {:==, [context: Elixir, import: Kernel], [3, 5]},
          [
            do: [
              {:->, [],
                [
                  [
                    {:when, [],
                    [
                      {:x, [counter: -576460752303420860], Kernel},
                      {{:., [], [Kernel, :in]}, [],
                        [{:x, [counter: -576460752303420860], Kernel}, [false, nil]]}
                    ]}
                  ],
                  "foo"
                ]},
              {:->, [], [[{:_, [], Kernel}], nil]}
            ]
          ]
        ]}
  """

  # recompile(); require Meta.CH01; import Meta.CH01

  defmacro say({operator, _, [a, b]}) do
    quote do
      operator = unquote(operator)
      verb = to_verb(operator)

      a = unquote(a)
      b = unquote(b)
      result = apply(Kernel, operator, [a, b])

      IO.puts("#{a} #{verb} #{b} is #{result}")

      result
    end
  end

  def to_verb(:+), do: "plus"
  def to_verb(:-), do: "minus"
  def to_verb(:*), do: "times"
  def to_verb(:/), do: "divided by"
end
