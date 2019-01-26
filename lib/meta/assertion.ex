defmodule Meta.Assertion do
  # recompile(); alias Meta.Assertion; require Assertion; import Assertion;
  defmacro assert({operator, _, [left, right]}) do
    quote bind_quoted: [operator: operator, left: left, right: right] do
      Meta.Assertion.Test.assert(operator, left, right)
    end
  end
end
