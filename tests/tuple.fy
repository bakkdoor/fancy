FancySpec describe: Tuple with: {
  it: "have the correct amount of elements" for: 'size when: {
    (1,2) size should == 2
    (1,2,3) size should == 3
    ('foo, "bar", 'baz, 123) size should == 4
  }

  it: "should have the correct items at a given index" for: 'at: when: {
    tuple = ("foo", 'bar, "baz")
    tuple at: 0 . should == "foo"
    tuple at: 1 . should == 'bar
    tuple at: 2 . should == "baz"
  }

  it: "should have the correct items at a given index" for: '[] when: {
    tuple = ("foo", 'bar, "baz")
    tuple[0] . should == "foo"
    tuple[1] . should == 'bar
    tuple[2] . should == "baz"
  }
}
