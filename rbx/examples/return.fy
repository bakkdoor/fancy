def foo: block {
  1 upto: 10 do_each: |i| {
    block call: [i] . if_true: {
      return i # non-local return from "foo:"
    }
  }
  return "yay"
}

foo: |x| { x == 6 } . println
foo: |x| { x == 0 } . println
