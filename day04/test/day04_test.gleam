import day04.{Assignment, contains, one_contains_other, parse_line, solve1}
import gleeunit

const testfile = "ressources/test.txt"

const a = Assignment(2, 4)

const b = Assignment(3, 4)

const c = Assignment(1, 2)

const d = Assignment(1, 1)

pub fn contains_test() {
  assert contains(c, d)
  assert !contains(d, c)
  assert contains(a, b)
  assert !contains(b, a)
  assert !contains(b, d)
}

pub fn contains_other_test() {
  assert one_contains_other(a, b) && one_contains_other(b, a)
}

pub fn parse_line_test() {
  let assert Ok(tup) = parse_line("2-4,3-4")
  assert tup.0 == a
  assert tup.1 == b
  let err_msg = "Cant parse String: hello"
  assert parse_line("hello") == Error(err_msg)
}

pub fn solve1_test() {
  assert solve1(testfile) == Ok(2)
}

pub fn main() -> Nil {
  gleeunit.main()
}
