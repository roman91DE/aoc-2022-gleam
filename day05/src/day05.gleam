import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type Stack {
  Stack(name: String, elems: List(String))
}

pub fn read_file(path: String) -> Result(String, String) {
  simplifile.read(path)
  |> result.map_error(fn(err) { simplifile.describe_error(err) })
}

pub fn split_parts(txt: String) -> Result(#(String, String), String) {
  case txt |> string.split_once("\n\n") {
    Ok(#(a, b)) -> Ok(#(a, string.trim_end(b)))
    _ -> Error("Error while trying to split input")
  }
}

pub fn parse_stacks(txt: String) -> Result(List(Stack), String) {
  txt |> string.split("\n") |> parse_stacks_loop([])
}

pub fn parse_footer(s: String) -> List(String) {
  s
  |> string.split(" ")
  |> list.map(string.trim)
  |> list.filter(fn(x) { string.length(x) > 0 })
}

pub fn parse_stack_line(s: String) -> List(String) {
  s
  |> string.to_graphemes
  |> list.sized_chunk(4)
  |> list.map(fn(chunk) {
    case chunk {
      [_, c, ..] -> string.trim(c)
      _ -> ""
    }
  })
}

fn parse_stacks_loop(
  lines: List(String),
  acc: List(List(String)),
) -> Result(List(Stack), String) {
  case lines {
    [footer] -> {
      let stack_names = parse_footer(footer)
      let columns =
        acc
        |> list.transpose
        |> list.map(list.filter(_, fn(x) { x != "" }))
      let zippedr = list.strict_zip(stack_names, columns)
      case zippedr {
        Ok(zipped) -> Ok(zipped |> list.map(fn(tup) { Stack(tup.0, tup.1) }))
        _ -> Error("Stacks didnt match Names")
      }
    }
    [x, ..xs] -> {
      parse_stacks_loop(xs, [parse_stack_line(x), ..acc])
    }
    _ -> Error("Recursive Error")
  }
}

pub fn main() -> Nil {
  io.println("Hello from day05!")
}
