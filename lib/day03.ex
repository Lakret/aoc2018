defmodule Day03 do
  use Aoc2018

  defmodule Claim do
    @enforce_keys [:id, :left, :top, :width, :height]
    defstruct [:id, :left, :top, :width, :height]

    @claim_regex ~r/#(?<id>\d+) @ (?<left>\d+),(?<top>\d+): (?<width>\d+)x(?<height>\d+)/

    def parse_claim(claim) do
      with captured = %{} <- Regex.named_captures(@claim_regex, claim) do
        fields = Enum.map(captured, fn {k, v} -> {String.to_existing_atom(k), String.to_integer(v)} end)
        struct!(Claim, fields)
      end
    end
  end

  def part_one(claims) do
    claims
    |> Enum.map(&Claim.parse_claim/1)
    |> get_claims_map()
    |> Enum.filter(fn {_, v} -> length(v) >= 2 end)
    |> Enum.count()
  end

  @spec get_claims_map(list()) :: map()
  defp get_claims_map(claims) when is_list(claims) do
    Enum.reduce(claims, %{}, fn claim, claims_map ->
      Enum.reduce((claim.left + 1)..(claim.left + claim.width), claims_map, fn x, claims_map ->
        Enum.reduce((claim.top + 1)..(claim.top + claim.height), claims_map, fn y, claims_map ->
          Map.update(claims_map, {x, y}, [claim.id], &[claim.id | &1])
        end)
      end)
    end)
  end

  def part_two(claims) do
    {solution_set, _} =
      claims
      |> Enum.map(&Claim.parse_claim/1)
      |> get_claims_map()
      |> Map.values()
      |> Enum.reduce({MapSet.new(), MapSet.new()}, fn
        [unique_claim], acc = {candidates, eliminated} ->
          if unique_claim not in eliminated do
            {MapSet.put(candidates, unique_claim), eliminated}
          else
            acc
          end

        [], acc ->
          acc

        non_unique_claims, {candidates, eliminated} when is_list(non_unique_claims) ->
          non_unique_claims = MapSet.new(non_unique_claims)
          {MapSet.difference(candidates, non_unique_claims), MapSet.union(eliminated, non_unique_claims)}
      end)

    solution_set
    |> MapSet.to_list()
    |> hd
  end
end
