import day03.{
  find_items, priority, read_file, solve_part1, solve_part2, split_compartments,
}
import gleam/int
import gleam/list
import gleam/string
import gleeunit
import gleeunit/should

const inputfile_path = "ressources/puzzle.txt"

const testfile_path = "ressources/test.txt"

const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

pub fn all_even_test() {
  let lines = read_file(testfile_path) |> string.split("\n")
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

pub fn priority_test() {
  should.equal(priority("p"), Ok(16))
  should.equal(priority("L"), Ok(38))
  should.equal(priority("P"), Ok(42))
  should.equal(priority("v"), Ok(22))
  should.be_error(priority("!"))
}

pub fn find_item_test() {
  should.equal(find_items("ab", "ac"), Ok("a"))
  should.equal(find_items("aba", "aca"), Ok("a"))
  should.equal(find_items("a", "b"), Error(Nil))
}

pub fn solve_part1_test() {
  let tst_result = solve_part1(testfile_path)
  should.equal(tst_result, Ok(157))
}

pub fn solve_part2_test() {
  let tst_result = solve_part2(testfile_path)
  should.equal(tst_result, 70)
}

pub fn main() -> Nil {
  gleeunit.main()
}
