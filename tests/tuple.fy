FancySpec describe: Tuple with: {
  it: "have the correct amount of elements" for: 'size when: {
    (1,2) size is == 2
    (1,2,3) size is == 3
    ('foo, "bar", 'baz, 123) size is == 4
  }

  it: "should have the correct items at a given index" for: 'at: when: {
    tuple = ("foo", 'bar, "baz")
    tuple at: 0 . is == "foo"
    tuple at: 1 . is == 'bar
    tuple at: 2 . is == "baz"
  }

  it: "should have the correct items at a given index" for: '[] when: {
    tuple = ("foo", 'bar, "baz")
    tuple[0] . is == "foo"
    tuple[1] . is == 'bar
    tuple[2] . is == "baz"
  }

  it: "should create a new tuple with values set to nil" for: 'new: when: {
    t = Tuple new: 2
    t size is == 2
    t[0] is == nil
    t[1] is == nil
  }

  it: "should not allow to create an empty Tuple" for: 'new when: {
    { Tuple new } raises: ArgumentError
  }

  it: "should not allow to create a Tuple with less than 2 elements" for: 'new: when: {
    { Tuple new: -1 } raises: ArgumentError
    { Tuple new: 0 } raises: ArgumentError
    { Tuple new: 1 } raises: ArgumentError
    { Tuple new: 2 } does_not raise: ArgumentError
  }
}
