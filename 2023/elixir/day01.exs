defmodule Day01 do
  def part1(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.reduce(0, fn l, acc ->
      matches =
        Regex.scan(~r/\d/, l)
        |> List.flatten()
      first = hd(matches)
      last = List.last(matches)
      acc + String.to_integer(first <> last)
    end)
  end

  def part2(filename) do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.reduce(0, fn l, acc ->
      matches =
        Regex.scan(~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/, l)
        |> List.flatten()
        |> Enum.reject(fn x -> x == "" end)
      first = hd(matches)
        |> letter_digit_to_number()
      last = List.last(matches)
        |> letter_digit_to_number()
      acc + String.to_integer(first <> last)
    end)
  end

  @conversion %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  defp letter_digit_to_number(digit) do
    Map.get(@conversion, digit, digit)
  end
end

IO.puts("Day 01 | Part 1 | Test: #{Day01.part1("./day01_1.test")}")
IO.puts("Day 01 | Part 1 | Data: #{Day01.part1("./day01.input")}")
IO.puts("Day 01 | Part 2 | Test: #{Day01.part2("./day01_2.test")}")
IO.puts("Day 01 | Part 2 | Data: #{Day01.part2("./day01.input")}")

