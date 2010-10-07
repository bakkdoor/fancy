require: "lib/division_by_zero"

y = 0
x = 0
try {
  x = 10 / y
} catch DivisionByZeroError => e {
  y println
  x println
  y = 2
  retry # not working yet
}
y println
x println
