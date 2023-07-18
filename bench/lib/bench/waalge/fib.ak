/// Compute the `nth` number in the fibonacci sequence starting from `l` and `r`
pub fn fib(l: Int, r: Int, n: Int) -> Int {
  if n < 0 {
    error @"Impossible"
  } else {
    when n is {
      0 -> l
      1 -> r
      _ -> fib(r, l + r, n - 1)
    }
  }
}
