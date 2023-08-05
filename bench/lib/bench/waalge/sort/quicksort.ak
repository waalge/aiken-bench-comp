use aiken/list

pub fn sort(xs: List<Int>) -> List<Int> {
  when xs is {
    [] ->
      []
    [p, ..tail] -> {
      let before = tail |> list.filter(fn(x) { x < p }) |> sort
      let after = tail |> list.filter(fn(x) { x >= p }) |> sort
      list.concat(before, [p, ..after])
    }
  }
}
