FancySpec describe: "Assignment" with: {
  it: "should correctly assign multiple values at once" when: {
    x, y, z = 1, 10, 100
    x should == 1
    y should == 10
    z should == 100

    x, y, z = 'foo, 'bar
    x should == 'foo
    y should == 'bar
    z should == nil

    x = 'foo
    y = 'bar
    x, y = y, x
    x should == 'bar
    y should == 'foo
  }

  it: "should handle multiple assignment for any collection type implementing 'at:" when: {
    x, y, z = (1, 2, 3)
    x should == 1
    y should == 2
    z should == 3

    a, b, c = ["a", "b", "c"]
    a should == "a"
    b should == "b"
    c should == "c"

    e, f = ([1,2], "foo")
    e should == [1,2]
    f should == "foo"
  }

  it: "should handle multiple assignment with splat-identifiers" when: {
    x,y,z,*rest = [1,2,3,4,5,6,7]
    x should == 1
    y should == 2
    z should == 3
    rest should == [4,5,6,7]

    a,b,*c,*d,e = [1,2,3,4,5,6,7,8]
    a should == 1
    b should == 2
    c should == [3,4,5,6,7,8]
    d should == [4,5,6,7,8]
    e should == 5

    _,_,*z = "hello, world!" # ignore first 2 characters
    z should == "llo, world!"
  }
}