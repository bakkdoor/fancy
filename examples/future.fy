def foo {
  Thread sleep: 3000
  "FOO"
}

def + other {
  Thread sleep: 1500
  "PLUS"
}

def baz: num {
  Thread sleep: (num * 500)
  "BAZ"
}

"Start" println

f = self @ foo
f println  # print future object
?f println # access and print the future's value

f = self @ + 10
f println
?f println

f = self @ baz: 10
f println
?f println

"End" println