FancySpec describe: "Assignment" with: {
  it: "correctly assigns multiple values at once" when: {
    x, y, z = 1, 10, 100
    x is: 1
    y is: 10
    z is: 100

    x, y, z = 'foo, 'bar
    x is: 'foo
    y is: 'bar
    z is: nil

    x = 'foo
    y = 'bar
    x, y = y, x
    x is: 'bar
    y is: 'foo
  }

  it: "handles multiple assignment for any collection type implementing 'at:" when: {
    x, y, z = (1, 2, 3)
    x is: 1
    y is: 2
    z is: 3

    a, b, c = ["a", "b", "c"]
    a is: "a"
    b is: "b"
    c is: "c"

    e, f = ([1,2], "foo")
    e is: [1,2]
    f is: "foo"
  }

  it: "handles multiple assignment with splat-identifiers" when: {
    x,y,z,*rest = [1,2,3,4,5,6,7]
    x is: 1
    y is: 2
    z is: 3
    rest is: [4,5,6,7]

    a,b,*c,*d,e = [1,2,3,4,5,6,7,8]
    a is: 1
    b is: 2
    c is: [3,4,5,6,7,8]
    d is: [4,5,6,7,8]
    e is: 5

    _,_,*z = "hello, world!" # ignore first 2 characters
    z is: "llo, world!"
  }

  it: "sets dynamic vars accordingly" when: {
    let: '*foo* be: 10 in: {
      *foo* is: 10
    }
  }

  it: "sets a dynamic var with proper nesting" when: {
    def use_foo: expected {
      *foo* is: expected
    }

    def use_nested_foo: expected {
      use_foo: expected
      let: '*foo* be: -10 in: {
        use_foo: -10
      }
    }

    let: '*foo* be: 10 in: {
      *foo* is: 10
      use_foo: 10
      use_nested_foo: 10
      let: '*foo* be: 100 in: {
        *foo* is: 100
        use_foo: 100
        use_nested_foo: 100
      }
    }
  }

  it: "allows assigning dynamic vars without a scope" when: {
    *foo* = "hello, world"
    *foo* is: "hello, world"
    let: '*foo* be: "byebye, world" in: {
      *foo* is: "byebye, world"
      use_foo: "byebye, world"
      use_nested_foo: "byebye, world"
    }
    *foo* is: "hello, world"
    use_foo: "hello, world"
    use_nested_foo: "hello, world"
    *foo* = nil
    *foo* is: nil
    use_foo: nil
    use_nested_foo: nil
  }

  it: "preserves the current value of a dynvar when creating a new thread" when: {
    *foo* = 100
    *foo* is: 100
    Thread new: {
      *foo* is: 100
    } . join
  }
}