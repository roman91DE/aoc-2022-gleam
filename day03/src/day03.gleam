import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

const inputfile_path = "ressources/puzzle.txt"

const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

pub fn main() -> Nil {
  let p1 = solve_part1(inputfile_path)
  io.println("Day 3 - Part 1:")
  echo p1
  io.println("Parts 2:")
  let p2 = solve_part2(inputfile_path)
  echo p2
  Nil
}

pub fn split_compartments(line: String) -> #(String, String) {
  let n = line |> string.length
  let mid = int.divide(n, 2) |> result.unwrap(0)
  #(string.slice(line, 0, mid), string.slice(line, mid, mid))
}

pub fn priority(s: String) -> Result(Int, String) {
  let assert Ok(c) = string.first(s) as "priority: empty string"
  let assert Ok(cp) = string.utf_codepoint(33) as "33 is !, this cant fail"
  let ascii_val = case
    string.to_utf_codepoints(c)
    |> list.first
    |> result.unwrap(cp)
    |> string.utf_codepoint_to_int
  {
    n if n > 64 && n < 91 -> Ok(n)
    n if n > 96 && n < 123 -> Ok(n)
    _ -> Error(Nil)
  }
  case ascii_val {
    Ok(lc) if lc > 96 -> Ok(lc - 96)
    Ok(uc) if uc < 92 -> Ok(uc - 64 + 26)
    _ -> Error("priority: Invalid Code Point")
  }
}

pub fn find_items(s1: String, s2: String) -> Result(String, Nil) {
  let first = string.to_graphemes(s1)
  let second = string.to_graphemes(s2)
  let contained_in =
    first |> list.map(fn(c) { list.contains(second, c) }) |> list.zip(first)
  let match = contained_in |> list.filter(fn(tup) { tup.0 }) |> list.first
  case match {
    Ok(#(True, s)) -> Ok(s)
    _ -> Error(Nil)
  }
}

pub fn read_file(path: String) -> String {
  simplifile.read(path) |> result.unwrap("")
}

pub fn line_contains(line: String, c: String) -> Bool {
  line |> string.contains(c)
}

pub fn solve_part2(path: String) -> Int {
  let lines = read_file(path) |> string.split("\n")
  loop_part2(lines, 0)
}

fn loop_part2(lines: List(String), acc: Int) -> Int {
  case lines {
    [] -> acc
    [a, b, c, ..rest] -> {
      let matches =
        list.map(string.to_graphemes(chars), fn(ch) {
          #(
            ch,
            string.contains(a, ch)
              && string.contains(b, ch)
              && string.contains(c, ch),
          )
        })
      let match =
        list.filter(matches, fn(tup) { tup.1 })
        |> list.map(fn(tup) { tup.0 })
        |> list.first
        |> result.unwrap("!")
      let pr = result.unwrap(priority(match), 0)
      loop_part2(rest, acc + pr)
    }
    _ -> acc
  }
}

pub fn solve_part1(p: String) -> Result(Int, String) {
  let lines = read_file(p) |> string.split("\n")
  let pairs = list.map(lines, split_compartments)
  let items =
    list.map(pairs, fn(tup) { find_items(tup.0, tup.1) }) |> result.all
  let priorities = case items {
    Ok(lst) -> list.map(lst, priority) |> result.all
    Error(_) -> Error("Error: No matching Chars found")
  }
  case priorities {
    Ok(lst) -> Ok(list.reduce(lst, int.add) |> result.unwrap(0))
    Error(s) -> Error(s)
  }
}
