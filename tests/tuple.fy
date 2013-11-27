FancySpec describe: Tuple with: {
  it: "has the correct amount of elements" with: 'size when: {
    (1,2) size is: 2
    (1,2,3) size is: 3
    ('foo, "bar", 'baz, 123) size is: 4
  }

  it: "has the correct items at a given index" with: 'at: when: {
    tuple = ("foo", 'bar, "baz")
    tuple at: 0 . is: "foo"
    tuple at: 1 . is: 'bar
    tuple at: 2 . is: "baz"
  }

  it: "has the correct items at a given index" with: '[] when: {
    tuple = ("foo", 'bar, "baz")
    tuple[0] . is: "foo"
    tuple[1] . is: 'bar
    tuple[2] . is: "baz"
  }

  it: "creates a new tuple with values set to nil" with: 'new: when: {
    t = Tuple new: 2
    t size is: 2
    t[0] is: nil
    t[1] is: nil
  }

  it: "does not allow to create an empty Tuple" with: 'new when: {
    { Tuple new } raises: ArgumentError
  }

  it: "does not allow to create a Tuple with less than 2 elements" with: 'new: when: {
    { Tuple new: -1 } raises: ArgumentError
    { Tuple new: 0 } raises: ArgumentError
    { Tuple new: 1 } raises: ArgumentError
    { Tuple new: 2 } does_not raise: ArgumentError
  }

  it: "creates tuples dynamically" with: 'with_values: when: {
    Tuple with_values: [1,2,3] . is: (1,2,3)
    Tuple with_values: ["foo",'bar,42] . is: ("foo", 'bar, 42)
    Tuple with_values: ('hello, 'world) . is: ('hello, 'world)
    Tuple with_values: "test" . is: ("t","e","s","t")
  }

  it: "runs a Block for each element" with: 'each: when: {
    sum = 0
    vals = []
    (1,2,3) each: |x| {
      sum = sum + x
      vals << x
    }
    sum is: 6
    vals is: [1,2,3]
  }

  it: "runs a Block for each element in reverse order" with: 'reverse_each: when: {
    sum = 0
    vals = []
    (1,2,3) reverse_each: |x| {
      sum = sum + x
      vals << x
    }
    sum is: 6
    vals is: [3,2,1]
  }

  it: "returns an array of all elements between two indices" with: 'from:to: when: {
    (1,2) from: 2 to: 3 . is: []
    (1,2,3) from: 0 to: 2 . is: [1,2,3]
    (4,5,6,7,8,9) from: 3 to: 5 . is: [7,8,9]
    (1,2,3) from: 1 to: -1 . is: [2,3]
  }

  it: "returns a new tuple with the sum of elements" with: '+ when: {
    (1,2,3) + (4,5,6) is: (1,2,3,4,5,6)
    (1,2,3) + (1,2,3) is: (1,2,3,1,2,3)
    ("hello", "world") + "!" is: ("hello", "world", "!")
    (1,2) + [1,2,3] is: (1,2,1,2,3)
  }

  it: "returns a new tuple without any element in the given argument" with: '- when: {
    (1,2,3,4) - (2,3) is: (1,4)
    (1,2,3,2,1,2,3,2,1) - (1,2) is: (3,3)
    ((1,2), (3,4), (5,6)) - (3,4) is: ((1,2), (3,4), (5,6))
    ((1,2), (3,4), (5,6)) - [(3,4)] is: ((1,2), (5,6))
  }
}
