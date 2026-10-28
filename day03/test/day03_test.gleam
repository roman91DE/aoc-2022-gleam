import day03.{split_compartments}
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import gleeunit
import gleeunit/should
import simplifile

fn read_file(path: String) -> String {
  simplifile.read(path) |> result.unwrap("")
}

pub fn all_even_test() {
  let lines = read_file("ressources/test.txt") |> string.split("\n")
  let is_even = lines |> list.map(string.length) |> list.map(int.is_even)
  is_even |> list.map(should.be_true)
}

pub fn split_equal_length_test() {
  let lines = read_file("ressources/test.txt") |> string.split("\n")
  let equality_checks =
    lines
    |> list.map(split_compartments)
    |> list.map(fn(tup) { string.length(tup.0) == string.length(tup.1) })
  equality_checks |> list.map(should.be_true)
}

pub fn main() -> Nil {
  gleeunit.main()
}
