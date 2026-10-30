import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

const input_file = "ressources/input.txt"

pub type Assignment {
  Assignment(first: Int, last: Int)
}

pub fn contains(a: Assignment, b: Assignment) -> Bool {
  b.first >= a.first && b.last <= a.last
}

pub fn one_contains_other(a: Assignment, b: Assignment) -> Bool {
  contains(a, b) || contains(b, a)
}

pub fn parse_assignment(s: String) -> Result(Assignment, String) {
  case string.split(s, "-") {
    [start, end] -> {
      use istart <- result.try(
        int.parse(start) |> result.map_error(fn(_) { "Cant parse Int " <> s }),
      )
      use iend <- result.try(
        int.parse(end) |> result.map_error(fn(_) { "Cant parse Int " <> s }),
      )
      Ok(Assignment(istart, iend))
    }
    _ -> Error("Cant parse Assignment: " <> s)
  }
}

// pub fn parse_line(line: String) -> Result(#(Assignment, Assignment), String) {
//   case string.to_graphemes(line) {
//     [astart, "-", aend, ",", bstart, "-", bend] -> {
//       use asi <- result.try(
//         int.parse(astart)
//         |> result.map_error(fn(_) { "Cant parse Int " <> astart }),
//       )
//       use aei <- result.try(
//         int.parse(aend) |> result.map_error(fn(_) { "Cant parse Int " <> aend }),
//       )
//       use bsi <- result.try(
//         int.parse(bstart)
//         |> result.map_error(fn(_) { "Cant parse Int " <> bstart }),
//       )
//       use bei <- result.try(
//         int.parse(bend) |> result.map_error(fn(_) { "Cant parse Int " <> bend }),
//       )
//       Ok(#(Assignment(asi, aei), Assignment(bsi, bei)))
//     }
//     _ -> Error("Cant parse String: " <> line)
//   }
// }

pub fn parse_file(
  path: String,
) -> Result(List(#(Assignment, Assignment)), String) {
  use text <- result.try(
    simplifile.read(path)
    |> result.map_error(fn(e) {
      "simplifile error:" <> simplifile.describe_error(e)
    }),
  )
  let lines = text |> string.split("\n")
  use tups <- result.try(list.map(lines, parse_line) |> result.all)
  Ok(tups)
}

pub fn solve1(path: String) -> Result(Int, String) {
  use tups <- result.try(parse_file(path))
  let counter =
    tups |> list.filter(fn(p) { one_contains_other(p.0, p.1) }) |> list.length
  Ok(counter)
}

pub fn main() -> Nil {
  io.println("Solution Part1:")
  let sol1 = solve1(input_file)
  echo sol1
  Nil
}
