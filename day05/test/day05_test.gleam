import day05 as d
import gleeunit

const testfile = "ressources/test.txt"

pub fn split_test() {
  let stack_part = "    [D]    \n[N] [C]    \n[Z] [M] [P]\n 1   2   3 "
  let instruction_part =
    "move 1 from 2 to 1\nmove 3 from 1 to 3\nmove 2 from 2 to 1\nmove 1 from 1 to 2"
  let assert Ok(txt) = d.read_file(testfile)
  let assert Ok(#(a, b)) = d.split_parts(txt)
  assert a == stack_part
  assert b == instruction_part
}

pub fn split_parts_error_test() {
  assert d.split_parts("no blank line here")
    == Error("Error while trying to split input")
}

pub fn parse_footer_test() {
  let s = "1   2 3      12  2"
  assert d.parse_footer(s) == ["1", "2", "3", "12", "2"]
}

pub fn parse_stack_line_test() {
  assert d.parse_stack_line("    [D]    ") == ["", "D", ""]
  assert d.parse_stack_line("[N] [C]    ") == ["N", "C", ""]
  assert d.parse_stack_line("[Z] [M] [P]") == ["Z", "M", "P"]
}

pub fn parse_stacks_test() {
  let assert Ok(txt) = d.read_file(testfile)
  let assert Ok(#(stacks, _)) = d.split_parts(txt)
  assert d.parse_stacks(stacks)
    == Ok([
      d.Stack("1", ["Z", "N"]),
      d.Stack("2", ["M", "C", "D"]),
      d.Stack("3", ["P"]),
    ])
}

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  let name = "Joe"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Joe!"
}
