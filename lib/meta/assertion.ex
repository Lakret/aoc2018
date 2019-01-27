defmodule Meta.Assertion do
  # recompile(); alias Meta.Assertion; import Assertion;

  # TODO: try:
  # • Implement assert for every operator in Elixir.
  # • Implement a refute macro for refutations.
  # • Run test cases in parallel within Assertion.Test.run/2 via spawned processes.
  # • Add reports for the module. Include pass/fail counts and execution time.

  # manual extension of modules: use `use` in practice instead!
  defmacro extend(_options \\ []) do
    quote do
      import unquote(__MODULE__)

      def run do
        IO.puts("Running the tests...")
      end
    end
  end

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)

      Module.register_attribute(__MODULE__, :tests, accumulate: true)

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run do
        Meta.Assertion.Test.run(@tests, __MODULE__)
      end
    end
  end

  defmacro test(description, do: test_block) do
    test_func = String.to_atom(description)

    quote do
      @tests {unquote(test_func), unquote(description)}

      def unquote(test_func)(), do: unquote(test_block)
    end
  end

  defmacro assert(value) when is_boolean(value) do
    quote bind_quoted: [value: value] do
      Meta.Assertion.Test.assert(value)
    end
  end

  defmacro assert({operator, _, [left, right]}) do
    quote bind_quoted: [operator: operator, left: left, right: right] do
      Meta.Assertion.Test.assert(operator, left, right)
    end
  end
end

defmodule Meta.Assertion.Test do
  def run(tests, module) do
    Enum.each(tests, fn {test_func, description} ->
      case apply(module, test_func, []) do
        :ok ->
          IO.write([
            IO.ANSI.light_green(),
            ".",
            IO.ANSI.default_color()
          ])

        {:fail, reason} ->
          IO.write(IO.ANSI.light_red())

          IO.puts("""

          ===============================================
          FAILURE: #{description}
          ===============================================
          #{reason}
          """)

          IO.write(IO.ANSI.default_color())
      end
    end)
  end

  def assert(true), do: :ok

  def assert(false) do
    {:fail,
     """
     Expected true,
     got      false.
     """}
  end

  def assert(:==, left, right) when left == right do
    :ok
  end

  def assert(:==, left, right) do
    {:fail,
     """
     Expected:       #{left}
     to be equal to: #{right}
     """}
  end

  def assert(:>, left, right) when left > right do
    :ok
  end

  def assert(:>, left, right) do
    {:fail,
     """
     Expected:           #{left}
     to be greater than: #{right}
     """}
  end
end

defmodule MathTest4 do
  use Meta.Assertion

  test "integers can be added and subtracted" do
    assert 2 + 3 == 5
    assert 5 - 5 == 10
  end

  test "integers can be multiplied and divided" do
    assert 5 * 5 == 25
    assert 10 / 2 == 5
  end
end

defmodule MathTest do
  import Meta.Assertion

  def run do
    assert 5 == 5
    assert 10 > 0
    assert 1 > 2
    assert 10 * 10 == 100
  end
end

defmodule MathTest2 do
  require Meta.Assertion
  Meta.Assertion.extend()
end

defmodule MathTest3 do
  use Meta.Assertion
end
