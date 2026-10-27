import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type Shape {
  Rock
  Paper
  Scissors
}

pub type Outcome {
  Draw
  Win
  Loss
}

pub fn score_round(you: Shape, other: Shape) -> Int {
  let shape_score = case you {
    Rock -> 1
    Paper -> 2
    Scissors -> 3
  }
  let game_score = case you, other {
    Rock, Scissors -> 6
    Rock, Paper -> 0
    Scissors, Paper -> 6
    Scissors, Rock -> 0
    Paper, Rock -> 6
    Paper, Scissors -> 0
    _, _ -> 3
  }
  shape_score + game_score
}

pub fn parse_shape(s: String) -> Result(Shape, String) {
  case s {
    "A" -> Ok(Rock)
    "B" -> Ok(Paper)
    "C" -> Ok(Scissors)
    _ -> Error("parse_shape: Shape" <> s <> "is not a known Symbol")
  }
}

pub fn parse_outcome(s: String) -> Result(Outcome, String) {
  case s {
    "X" -> Ok(Loss)
    "Y" -> Ok(Draw)
    "Z" -> Ok(Win)
    _ -> Error("parse_outcome: Outcome" <> s <> "is not a known Symbol")
  }
}

pub fn parse_line(s: String) -> Result(#(Shape, Shape), String) {
  use first <- result.try(
    string.first(s) |> result.replace_error("string.first: empty line"),
  )
  use second <- result.try(
    string.last(s) |> result.replace_error("string.last: empty line"),
  )
  use other <- result.try(parse_shape(first))
  use outcome <- result.try(parse_outcome(second))
  let you = case other, outcome {
    a, Draw -> a
    Rock, Win -> Paper
    Rock, Loss -> Scissors
    Paper, Win -> Scissors
    Paper, Loss -> Rock
    Scissors, Win -> Rock
    Scissors, Loss -> Paper
  }

  Ok(#(you, other))
}

fn parse_file(path: String) -> Result(List(#(Shape, Shape)), String) {
  use txt <- result.try(
    simplifile.read(path) |> result.replace_error("Error reading from file"),
  )
  let lines = txt |> string.split("\n")
  lines |> list.map(parse_line) |> result.all
}

pub fn solve(path: String) -> Result(Int, String) {
  use shapes <- result.try(parse_file(path))
  let score =
    shapes
    |> list.map(fn(tup) { score_round(tup.0, tup.1) })
    |> list.reduce(int.add)
  case score {
    Ok(n) -> Ok(n)
    Error(_) -> Error("Empty list of Shapes")
  }
}

pub fn main() -> Nil {
  case solve("assets/part1.txt") {
    Ok(n) -> io.println(int.to_string(n))
    Error(s) -> io.print_error(s)
  }
}
