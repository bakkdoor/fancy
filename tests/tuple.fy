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
}
