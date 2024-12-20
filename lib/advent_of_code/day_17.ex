defmodule CPU do
  @moduledoc false

  defstruct register_a: 0,
            register_b: 0,
            register_c: 0,
            instruction_pointer: 0,
            instructions: [],
            output: []
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

  import Bitwise

  def part1(cpu) do
    simulate(cpu)
  end

  def simulate(
        %CPU{
          register_a: a,
          register_b: b,
          register_c: c,
          instruction_pointer: ip,
          instructions: instructions,
          output: out
        } = cpu
      ) do
    current_instruction = Enum.at(instructions, ip)
    current_operand = Enum.at(instructions, ip + 1)

    if current_instruction do
      new_cpu =
        case current_instruction do
          @adv ->
            op = combo_operand(cpu, current_operand)
            %{cpu | register_a: div(a, 2 ** op), instruction_pointer: ip + 2}

          @bxl ->
            %{cpu | register_b: bxor(b, current_operand), instruction_pointer: ip + 2}

          @bst ->
            op = combo_operand(cpu, current_operand)
            %{cpu | register_b: rem(op, 8), instruction_pointer: ip + 2}

          @jnz ->
            jnz(cpu, current_operand)

          @bxc ->
            %{cpu | register_b: bxor(b, c), instruction_pointer: ip + 2}

          @out ->
            op = combo_operand(cpu, current_operand)
            %{cpu | output: [rem(op, 8) | out], instruction_pointer: ip + 2}

          @bdv ->
            op = combo_operand(cpu, current_operand)
            %{cpu | register_b: div(a, 2 ** op), instruction_pointer: ip + 2}

          @cdv ->
            op = combo_operand(cpu, current_operand)
            %{cpu | register_c: div(a, 2 ** op), instruction_pointer: ip + 2}
        end

      simulate(new_cpu)
    else
      Enum.reverse(out)
    end
  end

  defp jnz(%CPU{register_a: a, instruction_pointer: ip} = cpu, op) do
    new_ip = if(a == 0, do: ip + 2, else: op)
    %{cpu | instruction_pointer: new_ip}
  end

  def combo_operand(%CPU{register_a: a, register_b: b, register_c: c}, operand) do
    case operand do
      op when op in 0..3 -> op
      4 -> a
      5 -> b
      6 -> c
      7 -> raise "combo operand 7 is invalid!"
    end
  end

  def part2(_args) do
  end
end
