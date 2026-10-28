import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from day03!")
}

pub fn split_compartments(line: String) -> #(String, String) {
  let n = line |> string.length
  let mid = int.divide(n, 2) |> result.unwrap(0)
  #(string.slice(line, 0, mid), string.slice(line, mid, mid))
}
