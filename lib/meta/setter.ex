defmodule Meta.Setter do
  @moduledoc """
  Demonstrates hygiene (p. 20)

  ## Examples

      iex> name = "foo"
      "foo"
      iex> Setter.bind_name_hygiene("bar")
      "bar"
      iex> name
      "foo"
      iex> Setter.bind_name("bar")
      "bar"
      iex> name
      "bar"
  """
  # will not work because of hygiene!
  defmacro bind_name_hygiene(new_name) do
    quote do
      name = unquote(new_name)
    end
  end

  # will work because we override hygiene with var!
  defmacro bind_name(new_name) do
    quote do
      var!(name) = unquote(new_name)
    end
  end

  # we can produce AST directly, without quote
  defmacro bind_name_manual(new_name) do
    {
      :=,
      [],
      [
        {:var!, [context: Elixir, import: Kernel], [{:name, [], Elixir}]},
        new_name
      ]
    }
  end
end
