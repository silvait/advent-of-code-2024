defmodule CPU do
  @moduledoc false

  defstruct register_a: 0,
            register_b: 0,
            register_c: 0,
            ip: 0,
            instructions: [],
            output: [],
            state: :running
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

  def solve(
        %CPU{register_a: a} = cpu,
        [current_guess | remaining_guesses],
        [current_instruction | remaining_instructions] = instructions
      ) do
    # shift a 3 bits left and add the current_guess to the end
    candidate_cpu = %{cpu | register_a: a * 8 + current_guess}

    case run_and_check(candidate_cpu) do
      %CPU{output: [^current_instruction]} ->
        solve(candidate_cpu, @all_octals, remaining_instructions) ||
          solve(cpu, remaining_guesses, instructions)

      _ ->
        solve(cpu, remaining_guesses, instructions)
    end
  end

  def get_cpu_output(%CPU{} = cpu), do: Enum.reverse(cpu.output)

  def run_and_check(%CPU{state: :halted} = cpu), do: cpu
  # Break on first output
  def run_and_check(%CPU{output: [_]} = cpu), do: cpu
  def run_and_check(%CPU{} = cpu), do: cpu |> step() |> run_and_check()

  def run(%CPU{state: :halted} = cpu), do: cpu
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

  def execute_instruction(cpu, [0, operand]), do: divide_a(cpu, operand, :register_a)
  def execute_instruction(cpu, [1, operand]), do: xor_b_and_operand(cpu, operand)
  def execute_instruction(cpu, [2, operand]), do: b_mod_operand(cpu, operand)
  def execute_instruction(cpu, [3, operand]), do: jump_if_not_zero(cpu, operand)
  def execute_instruction(cpu, [4, _operand]), do: xor_b_and_c(cpu)
  def execute_instruction(cpu, [5, operand]), do: output(cpu, operand)
  def execute_instruction(cpu, [6, operand]), do: divide_a(cpu, operand, :register_b)
  def execute_instruction(cpu, [7, operand]), do: divide_a(cpu, operand, :register_c)
  def execute_instruction(cpu, _instruction_and_operand), do: halt(cpu)

  defp halt(cpu), do: %{cpu | state: :halted}

  defp xor_b_and_c(%CPU{register_b: b, register_c: c} = cpu) do
    %{cpu | register_b: Bitwise.bxor(b, c)}
  end

  defp xor_b_and_operand(%CPU{register_b: b} = cpu, operand) do
    %{cpu | register_b: Bitwise.bxor(b, operand)}
  end

  defp b_mod_operand(cpu, operand) do
    %{cpu | register_b: rem(combo_operand(cpu, operand), 8)}
  end

  defp divide_a(%CPU{register_a: a} = cpu, operand, target_register) do
    %{cpu | target_register => div(a, 2 ** combo_operand(cpu, operand))}
  end

  defp output(%CPU{output: out} = cpu, operand) do
    %{cpu | output: [rem(combo_operand(cpu, operand), 8) | out]}
  end

  # No-op
  defp jump_if_not_zero(%CPU{register_a: 0} = cpu, _operand), do: cpu
  # Adjust operand to offset automatic instruction pointer incrementing
  defp jump_if_not_zero(%CPU{} = cpu, operand), do: jump_to(cpu, operand - @instruction_size)

  defp increment_instruction_pointer(%CPU{} = cpu), do: jump_to(cpu, cpu.ip + @instruction_size)

  defp jump_to(cpu, index), do: %{cpu | ip: index}

  def combo_operand(_cpu, operand) when operand in 0..3, do: operand
  def combo_operand(%CPU{register_a: a}, 4), do: a
  def combo_operand(%CPU{register_b: b}, 5), do: b
  def combo_operand(%CPU{register_c: c}, 6), do: c
  def combo_operand(_cpu, operand), do: raise("invalid combo operand '#{operand}'")
end
