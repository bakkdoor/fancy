y = 0
x = 0
try {
  x = 10 / y
} catch ZeroDivisionError {
  y println
  x println
  y = 2
  retry
}
y println
x println
