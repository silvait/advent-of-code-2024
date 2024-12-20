defmodule CPU do
  @moduledoc false

  defstruct register_a: 0,
            register_b: 0,
            register_c: 0,
            instruction_pointer: 0,
            instructions: [],
            output: [],
            state: :running
end

defmodule AdventOfCode.Day17 do
  @moduledoc false

  @adv 0
  @bxl 1
  @bst 2
  @jnz 3
  @bxc 4
  @out 5
  @bdv 6
  @cdv 7
  @instruction_size 2

  import Bitwise

  def part1(cpu) do
    cpu |> run() |> get_cpu_output()
  end

  def get_cpu_output(%CPU{output: output}) do
    Enum.reverse(output)
  end

  def run(%CPU{state: :halted} = cpu), do: cpu

  def run(%CPU{} = cpu) do
    cpu
    |> get_instruction_and_operand()
    |> then(&execute_instruction(cpu, &1))
    |> increment_instruction_pointer()
    |> run()
  end

  def get_instruction_and_operand(%CPU{instruction_pointer: ip, instructions: instructions}) do
    Enum.slice(instructions, ip, @instruction_size)
  end

  def execute_instruction(cpu, [@adv, operand]), do: divide_a(cpu, operand, :register_a)
  def execute_instruction(cpu, [@bdv, operand]), do: divide_a(cpu, operand, :register_b)
  def execute_instruction(cpu, [@cdv, operand]), do: divide_a(cpu, operand, :register_c)
  def execute_instruction(cpu, [@bxl, operand]), do: xor_b_and_operand(cpu, operand)
  def execute_instruction(cpu, [@bxc, _operand]), do: xor_b_and_c(cpu)
  def execute_instruction(cpu, [@bst, operand]), do: b_mod_operand(cpu, operand)
  def execute_instruction(cpu, [@jnz, operand]), do: jump_if_not_zero(cpu, operand)
  def execute_instruction(cpu, [@out, operand]), do: output(cpu, operand)
  def execute_instruction(cpu, _instruction_and_operand), do: halt(cpu)

  defp halt(cpu), do: %{cpu | state: :halted}

  defp xor_b_and_c(%CPU{register_b: b, register_c: c} = cpu) do
    %{cpu | register_b: bxor(b, c)}
  end

  defp xor_b_and_operand(%CPU{register_b: b} = cpu, operand) do
    %{cpu | register_b: bxor(b, operand)}
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

  defp increment_instruction_pointer(%CPU{instruction_pointer: ip} = cpu) do
    jump_to(cpu, ip + @instruction_size)
  end

  defp jump_to(cpu, index), do: %{cpu | instruction_pointer: index}

  def combo_operand(%CPU{} = cpu, operand) do
    case operand do
      op when op in 0..3 -> op
      4 -> cpu.register_a
      5 -> cpu.register_b
      6 -> cpu.register_c
      7 -> raise "combo operand 7 is invalid!"
    end
  end

  def part2(_args) do
  end
end
