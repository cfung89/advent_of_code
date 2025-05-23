defmodule Day02 do
  @max_vals %{ "red" => 12, "green" => 13, "blue" => 14 }

  def part1(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      String.split(x, ":", trim: true)
      |> Enum.at(1)
      |> String.split(";", trim: true)
      |> Enum.map(fn x ->
        Regex.scan(~r/\d+|red|green|blue/, x)
        |> List.flatten()
        |> Enum.chunk_every(2, 2, :discard)
        |> Enum.map(fn [v, k] -> {k, String.to_integer(v)} end)
      end)
      |> Enum.map(&Enum.reduce(&1, true, fn {k, v}, acc ->
        acc and Map.get(@max_vals, k) >= v
      end))
    end)
    |> Enum.reduce({1, 0}, fn ls, {idx, sum} ->
      if Enum.all?(ls) do
        {idx + 1, sum + idx}
      else
        {idx + 1, sum}
      end
    end)
    |> elem(1)
  end

  def part2(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      String.split(x, ":", trim: true)
      |> Enum.at(1)
      |> String.split(";", trim: true)
      |> Enum.map(fn x ->
        Regex.scan(~r/\d+|red|green|blue/, x)
        |> List.flatten()
        |> Enum.chunk_every(2, 2, :discard)
        |> Enum.map(fn [v, k] -> {k, String.to_integer(v)} end)
        |> Map.new()
      end)
      |> Enum.reduce(%{}, fn t, acc ->
        Map.merge(acc, t, fn _k, v1, v2 -> max(v1, v2) end)
      end)
      |> Enum.reduce(1, fn t, acc -> acc * elem(t, 1) end)
    end)
    |> Enum.reduce(&+/2)
  end
end

IO.puts("Day 02 | Part 1 | Test: #{Day02.part1("./day02.test")}")
IO.puts("Day 02 | Part 1 | Data: #{Day02.part1("./day02.input")}")
IO.puts("Day 02 | Part 2 | Test: #{Day02.part2("./day02.test")}")
IO.puts("Day 02 | Part 2 | Data: #{Day02.part2("./day02.input")}")
