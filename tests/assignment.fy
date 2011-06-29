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
}