import gleam/io
import gleam/list

fn ntimes(n: Int, xs: List(t)) -> List(t) {
  xs |> list.flat_map(fn(x) { list.repeat(x, n) })
}

pub fn main() -> Nil {
  let xs = [1, 2, 3]
  let ys = ntimes(4, xs)
  echo ys
  io.println(".")
}
