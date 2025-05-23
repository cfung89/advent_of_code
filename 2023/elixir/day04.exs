defmodule Day04 do
  def part1(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      String.split(x, ":", trim: true)
      |> Enum.at(1)
      |> String.split("|", trim: true)
      |> List.to_tuple()
      |> then(fn t ->
        winning = MapSet.new(String.split(elem(t, 0), " ", trim: true))
        current =  MapSet.new(String.split(elem(t, 1), " ", trim: true))
        MapSet.intersection(winning, current) |> MapSet.size()
      end)
    end)
    |> Enum.reduce(0, fn x, acc ->
      if x - 1 >= 0, do: acc + Integer.pow(2, x - 1), else: acc
    end)
  end

  def part2(filename) do
    lines = File.read!(filename)
      |> String.split("\n", trim: true)
    max_card = length(lines)
    Enum.map(lines, fn x ->
      String.split(x, ":", trim: true)
      |> Enum.at(1)
      |> String.split("|", trim: true)
      |> List.to_tuple()
      |> then(fn t ->
        winning = MapSet.new(String.split(elem(t, 0), " ", trim: true))
        current =  MapSet.new(String.split(elem(t, 1), " ", trim: true))
        MapSet.intersection(winning, current) |> MapSet.size()
      end)
    end)
    |> Enum.with_index(1)
    |> Enum.reduce(%{}, fn {x, card}, acc ->
      l = card + 1
      r = min(card + x, max_card)
      if x !== 0 do
        Enum.reduce(l..r, acc, fn y, m ->
          Map.put(m, y, Map.get(m, y, 1) + Map.get(m, card, 1))
        end)
        |> Map.put(card, Map.get(acc, card, 1))
      else
        Map.put(acc, card, Map.get(acc, card, 1))
      end
    end)
    |> Enum.reduce(0, fn {_k, v}, acc -> acc + v end)
  end
end

IO.puts("Day 04 | Part 1 | Test: #{Day04.part1("./day04.test")}")
IO.puts("Day 04 | Part 1 | Data: #{Day04.part1("./day04.input")}")
IO.puts("Day 04 | Part 2 | Test: #{Day04.part2("./day04.test")}")
IO.puts("Day 04 | Part 2 | Data: #{Day04.part2("./day04.input")}")
