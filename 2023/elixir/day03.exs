defmodule Day03 do
  def part1(filename) do
    strings = File.read!(filename)
      |> String.split("\n", trim: true)
    pos_d = Enum.map(strings, fn l ->
      Regex.scan(~r/\d+/, l, return: :index)
      |> List.flatten()
    end)
    pos_s = Enum.map(strings, fn l ->
      Regex.scan(~r/\+|\-|\*|\/|\#|\@|\=|\&|\%|\$/, l, return: :index)
      |> List.flatten()
    end)
    all_pos_s = Enum.with_index(pos_s)
      |> Enum.map(fn {list, idx} ->
        Enum.reduce(list, [], fn {x, len}, acc ->
          Enum.map(0..len-1, fn y -> acc ++ [{idx, x + y}] end)
        end)
      end)
      |> List.flatten()
    Enum.with_index(pos_d)
    |> Enum.map(fn {list, idx} ->
      Enum.map(list, fn {x, len} ->
        cur = -1..len
          |> Enum.flat_map(fn y -> [{idx - 1, x + y}, {idx + 1, x + y}] end)
          |> then(&(&1 ++ [{idx, x - 1}, {idx, x + len}]))
        if not MapSet.disjoint?(MapSet.new(all_pos_s), MapSet.new(cur)) do
          ending = Enum.take(cur, -2)
          line_num = Enum.at(ending, 0) |> elem(0)
          start_num = elem(Enum.at(ending, 0), 1) + 1
          end_num = elem(Enum.at(ending, 1), 1) - 1
          Enum.at(strings, line_num)
          |> String.slice(start_num..end_num)
          |> String.to_integer()
        else
          0
        end
      end)
    end)
    |> List.flatten()
    |> Enum.reduce(0, &+/2)
  end

  def part2(filename) do
    strings = File.read!(filename)
      |> String.split("\n", trim: true)
    pos_d = Enum.map(strings, fn l ->
      Regex.scan(~r/\d+/, l, return: :index)
      |> List.flatten()
    end)
    pos_s = Enum.map(strings, fn l ->
      Regex.scan(~r/\*/, l, return: :index)
      |> List.flatten()
    end)
    all_pos_s = Enum.with_index(pos_s)
      |> Enum.map(fn {list, idx} ->
        Enum.reduce(list, [], fn {x, len}, acc ->
          Enum.map(0..len-1, fn y -> acc ++ [{idx, x + y}] end)
        end)
      end)
      |> List.flatten()

    Enum.with_index(pos_d)
    |> Enum.reduce({[], [], %{}}, fn {list, idx}, {out, ls_t, num_t} ->
      Enum.reduce(list, {out, ls_t, num_t}, fn {x, len}, {out, ls_t, num_t} ->
        # list of points around each number
        cur = -1..len
          |> Enum.flat_map(fn y -> [{idx - 1, x + y}, {idx + 1, x + y}] end)
          |> then(&(&1 ++ [{idx, x - 1}, {idx, x + len}]))

        # check position of all "*" and match with points surrounding numbers
        Enum.reduce(all_pos_s, {out, ls_t, num_t}, fn s, {out, ls_t, num_t} ->
          if s in cur do
            if s not in ls_t do
              {out, [s | ls_t], Map.put(num_t, s, cur)}
            else
              {[find_num(strings, cur) * find_num(strings, Map.fetch!(num_t, s)) | out], ls_t, num_t}
            end
          else
            { out, ls_t, num_t }
          end
        end)
      end)
    end)
    |> elem(0)
    |> Enum.reduce(0, &+/2)
  end

  def find_num(strings, cur) do
    ending = Enum.take(cur, -2)
    line_num = Enum.at(ending, 0) |> elem(0)
    start_num = elem(Enum.at(ending, 0), 1) + 1
    end_num = elem(Enum.at(ending, 1), 1) - 1
    Enum.at(strings, line_num)
    |> String.slice(start_num..end_num)
    |> String.to_integer()
  end
end

IO.puts("Day 03 | Part 1 | Test: #{Day03.part1("./day03.test")}")
IO.puts("Day 03 | Part 1 | Data: #{Day03.part1("./day03.input")}")
IO.puts("Day 03 | Part 2 | Test: #{Day03.part2("./day03.test")}")
IO.puts("Day 03 | Part 2 | Data: #{Day03.part2("./day03.input")}")
