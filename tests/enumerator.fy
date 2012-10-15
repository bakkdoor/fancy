FancySpec describe: Fancy Enumerator with: {
  it: "iterates with 'next" with: 'new: when: {
    enum = Fancy Enumerator new: (42..50)
    enum next is: 42
    enum next is: 43
  }

  it: "peeks to find next element" with: 'peek when: {
    enum = Fancy Enumerator new: (42..50)
    enum peek is: 42
    enum peek is: 42
    enum next is: 42

    enum peek is: 43
    enum peek is: 43
    enum next is: 43
  }

  it: "turns an object with 'each: into an Fancy Enumerator" with: 'to_enum when: {
    enum = (42..45) to_enum
    enum next is: 42
  }

  it: "turns an object with given method into an Fancy Enumerator" with: 'to_enum: when: {
    o = {}
    def o iter: block {
      1 upto: 10 do: block
    }
    enum = o to_enum: 'iter:
    enum next is: 1
  }

  it: "rewinds to the beginning of the iteration" with: 'rewind when: {
    enum = (42..45) to_enum
    check = {
      enum peek is: 42
      enum next is: 42
      enum peek is: 43
      enum next is: 43
    }

    check call
    enum rewind
    check call
  }

  it: "raises Fancy StopIteration when out of values" with: 'next when: {
    o = Object new
    def o each: block { block call: [1] }
    e = o to_enum

    e next is: 1
    try {
      e next
      "We is not reach this line" is: true
    } catch (Fancy StopIteration) => ex {
      ex result is: nil
    }
  }

  it: "sets result on Fancy StopIteration when out of values" with: 'next when: {
    o = Object new
    def o each: block {
      block call: [1]
      42
    }
    e = o to_enum

    e next is: 1
    try {
      e next
      "We is not reach this line" is: true
    } catch (Fancy StopIteration) => ex {
      ex result is: 42
    }
  }

  it: "iterates with an object" with: 'with:each: when: {
    enum = (42..45) to_enum
    result = enum with: [] each: |val, obj| { obj << val }
    result is: [42, 43, 44, 45]
  }

  it: "chunks up into enums" with: 'chunk: when: {
    enum = (1..42) to_enum
    chunked = enum chunk: |n| { n % 3 == 0 }
    chunked next is: [false, [1,2]]
    chunked next is: [true, [3]]
  }

  it: "converts to an Array" with: 'to_a when: {
    enum = (1..10) to_enum
    enum to_a is: [1,2,3,4,5,6,7,8,9,10]
  }

  it: "has ended (no more values left)" with: 'ended? when: {
    enum = (1..9) to_enum
    10 times: { enum ended? is: false; enum next } # move forward
    enum ended? is: true
  }

  it: "is an Enumerable" when: {
    enum = (1..9) to_enum
    enum select: 'even? . is: [2,4,6,8]
    enum rewind
    enum map: @{ + 1 } . is: $ (2..10) to_a
  }
}

# => [:each, :each_with_index, :each_with_object, :with_index, :with_object, :next_values, :peek_values, :next, :peek, :feed, :rewind, :inspect]
