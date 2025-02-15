defmodule CPU do
  @moduledoc false

  defstruct a: 0, b: 0, c: 0, ip: 0, instructions: [], output: []
end

defmodule AdventOfCode.Day17 do
  @moduledoc false

  @all_octals Enum.to_list(0..7)
  @instruction_size 2

  def part1(cpu), do: cpu |> run() |> get_cpu_output()

  def part2(instructions) do
    solve(%CPU{instructions: instructions}, @all_octals, Enum.reverse(instructions))
  end

  # output matched all instructions
  def solve(%CPU{} = cpu, _, []), do: cpu
  # no more guesses
  def solve(_, [], _), do: nil

  def solve(%CPU{a: a} = cpu, [guess | remaining_guesses], instructions) do
    # shift a 3 bits left and add the current_guess to the end
    new_cpu = %{cpu | a: a * 8 + guess}

    [expected_instruction | remaining_instructions] = instructions

    case run_and_check(new_cpu) do
      %CPU{output: [^expected_instruction]} ->
        solve(new_cpu, @all_octals, remaining_instructions) ||
          solve(cpu, remaining_guesses, instructions)

      _ ->
        solve(cpu, remaining_guesses, instructions)
    end
  end

  def get_cpu_output(%CPU{} = cpu), do: Enum.reverse(cpu.output)

  # CPU halted
  def run_and_check(%CPU{ip: nil} = cpu), do: cpu
  # Break on first output
  def run_and_check(%CPU{output: [_]} = cpu), do: cpu
  def run_and_check(%CPU{} = cpu), do: cpu |> step() |> run_and_check()

  # CPU halted
  def run(%CPU{ip: nil} = cpu), do: cpu
  def run(%CPU{} = cpu), do: cpu |> step() |> run()

  def step(%CPU{} = cpu) do
    cpu
    |> get_instruction_and_operand()
    |> then(&execute_instruction(cpu, &1))
    |> increment_instruction_pointer()
  end

  def get_instruction_and_operand(%CPU{ip: ip, instructions: instructions}) do
    Enum.slice(instructions, ip, @instruction_size)
  end

  def execute_instruction(cpu, [0, operand]), do: divide_a(cpu, operand, :a)
  def execute_instruction(cpu, [1, operand]), do: xor_b_and_operand(cpu, operand)
  def execute_instruction(cpu, [2, operand]), do: b_mod_operand(cpu, operand)
  def execute_instruction(cpu, [3, operand]), do: jump_if_not_zero(cpu, operand)
  def execute_instruction(cpu, [4, _operand]), do: xor_b_and_c(cpu)
  def execute_instruction(cpu, [5, operand]), do: output(cpu, operand)
  def execute_instruction(cpu, [6, operand]), do: divide_a(cpu, operand, :b)
  def execute_instruction(cpu, [7, operand]), do: divide_a(cpu, operand, :c)
  def execute_instruction(cpu, _instruction_and_operand), do: jump_to(cpu, nil)

  defp xor_b_and_c(%CPU{b: b, c: c} = cpu) do
    %{cpu | b: Bitwise.bxor(b, c)}
  end

  defp xor_b_and_operand(%CPU{b: b} = cpu, operand) do
    %{cpu | b: Bitwise.bxor(b, operand)}
  end

  defp b_mod_operand(cpu, operand) do
    %{cpu | b: rem(combo_operand(cpu, operand), 8)}
  end

  defp divide_a(%CPU{a: a} = cpu, operand, target_register) do
    %{cpu | target_register => div(a, 2 ** combo_operand(cpu, operand))}
  end

  defp output(%CPU{output: out} = cpu, operand) do
    %{cpu | output: [rem(combo_operand(cpu, operand), 8) | out]}
  end

  # No-op
  defp jump_if_not_zero(%CPU{a: 0} = cpu, _operand), do: cpu
  # Adjust operand to offset automatic instruction pointer incrementing
  defp jump_if_not_zero(%CPU{} = cpu, operand), do: jump_to(cpu, operand - @instruction_size)

  defp increment_instruction_pointer(%CPU{ip: nil} = cpu), do: cpu
  defp increment_instruction_pointer(%CPU{} = cpu), do: jump_to(cpu, cpu.ip + @instruction_size)

  defp jump_to(cpu, index), do: %{cpu | ip: index}

  def combo_operand(_cpu, operand) when operand in 0..3, do: operand
  def combo_operand(%CPU{a: a}, 4), do: a
  def combo_operand(%CPU{b: b}, 5), do: b
  def combo_operand(%CPU{c: c}, 6), do: c
  def combo_operand(_cpu, operand), do: raise("invalid combo operand '#{operand}'")
end
