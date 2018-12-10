defmodule Aoc2018 do
  @moduledoc """
  Provides macro injecting helpers for AoC solution modules.
  """

  defmacro __using__(_opts) do
    quote do
      @doc """
      Read first input file for the current day.

      Input files are stored in `$projectRoot/input` folder.
      Input filenames follow `day${day}_${part}` format, e.g. `day03_2`.
      """
      def read_input(), do: read_input_file("_1")

      @doc """
      Read second input file for the current day.

      See `read_input/0` for input files location and naming convention.
      """
      def read_input_part_two(), do: read_input_file("_2")

      defp get_module_input_filename_part() do
        [module_name | _] =
          __MODULE__
          |> Atom.to_string()
          |> String.split(".")
          |> Enum.reverse()

        String.downcase(module_name)
      end

      defp read_input_file(filename_suffix) do
        filename = get_module_input_filename_part() <> filename_suffix
        path = Path.join("input", filename)
        File.read!(path)
      end
    end
  end
end
