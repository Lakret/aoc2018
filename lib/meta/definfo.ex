defmodule Meta.DefInfo do
  defmacro definfo do
    IO.puts("In macro's context (#{__MODULE__})")

    quote do
      IO.puts("In caller's context (#{__MODULE__})")

      def friendly_info do
        IO.puts("""
        Hi, my name is #{__MODULE__}!
        I have these in store: #{inspect(__info__(:functions))}
        """)
      end
    end
  end
end

defmodule Meta.TestDefInfo do
  require Meta.DefInfo
  alias Meta.DefInfo

  DefInfo.definfo()
end
