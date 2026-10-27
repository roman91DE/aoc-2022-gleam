import day02.{
  type Shape, Paper, Rock, Scissors, parse_line, parse_shape, score_round, solve,
}
import gleeunit
import gleeunit/should

pub fn score_round_test() {
  score_round(Rock, Rock) |> should.equal(4)
}

pub fn parse_shape_test() {
  parse_shape("A") |> should.equal(Ok(Rock))
  parse_shape("s") |> should.be_error
}

pub fn parse_line_test() {
  parse_line("A X") |> should.equal(Ok(#(Rock, Rock)))
  parse_line("A X\n") |> should.be_error
  parse_line("lalala") |> should.be_error
}

pub fn solve_test() {
  solve("assets/test.txt") |> should.equal(Ok(15))
}

pub fn main() -> Nil {
  gleeunit.main()
}
