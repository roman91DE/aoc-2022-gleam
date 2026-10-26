import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

import simplifile

type Calories =
  Int

type Inventory =
  List(Calories)

fn sum_calories(inv: Inventory) -> Calories {
  inv |> list.fold(0, fn(a, b) { a + b })
}

fn most_calories(invs: List(Inventory)) -> Calories {
  let res =
    invs |> list.map(sum_calories) |> list.sort(int.compare) |> list.last
  case res {
    Ok(c) -> c
    Error(_) -> 0
  }
}

fn read_file(path: String) -> Result(String, Nil) {
  case simplifile.read(path) {
    Ok(text) -> Ok(text)
    Error(_) -> Error(Nil)
  }
}

fn process(s: String) -> List(List(String)) {
  let lines = string.split(s, "\n")
  let f = fn(acc: List(List(String)), line: String) {
    case acc, line {
      _, "" -> [[], ..acc]
      [cur, ..rest], txt -> [[txt, ..cur], ..rest]
      [], _ -> []
    }
  }
  list.fold(lines, [[]], f)
}

fn parse_ints(lst: List(String)) -> Result(List(Int), Nil) {
  lst |> list.map(int.parse) |> result.all
}

pub fn main() -> Nil {
  let txt = read_file("assets/lvl1.txt") |> result.unwrap("")
  let invs =
    process(txt) |> list.map(parse_ints) |> result.all |> result.unwrap([])
  io.print("Part 1: ")
  echo most_calories(invs)
  let result_two =
    invs
    |> list.map(sum_calories)
    |> list.sort(int.compare)
    |> list.reverse
    |> list.take(3)
    |> list.reduce(int.add)
  let two = case result_two{
    Ok(n) -> n
    _ -> 0
  }
  io.print("Part 2: ")
  echo two

  Nil
}
