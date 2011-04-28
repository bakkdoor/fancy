FancySpec describe: FancyEnumerator with: {
  it: "iterates with 'next" for: 'new: when: {
    enum = FancyEnumerator new: (42..50)
    enum next should == 42
    enum next should == 43
  }

  it: "peeks to find next element" for: 'peek when: {
    enum = FancyEnumerator new: (42..50)
    enum peek should == 42
    enum peek should == 42
    enum next should == 42

    enum peek should == 43
    enum peek should == 43
    enum next should == 43
  }

  it: "turns an object with 'each: into an FancyEnumerator" for: 'to_enum when: {
    enum = (42..45) to_enum
    enum next should == 42
  }

  it: "turns an object with given method into an FancyEnumerator" for: 'to_enum: when: {
    o = {}
    def o iter: block {
      1 upto: 10 do: block
    }
    enum = o to_enum: 'iter:
    enum next should == 1
  }

  it: "rewinds to the beginning of the iteration" for: 'rewind when: {
    enum = (42..45) to_enum
    check = {
      enum peek should == 42
      enum next should == 42
      enum peek should == 43
      enum next should == 43
    }

    check call
    enum rewind
    check call
  }

  it: "raises Fancy StopIteration when out of values" for: 'next when: {
    o = Object new
    def o each: block { block call: [1] }
    e = o to_enum

    e next should == 1
    try {
      e next
      "We should not reach this line" should == true
    } catch (Fancy StopIteration) => ex {
      ex result should == nil
    }
  }

  it: "sets result on Fancy StopIteration when out of values" for: 'next when: {
    o = Object new
    def o each: block {
      block call: [1]
      42
    }
    e = o to_enum

    e next should == 1
    try {
      e next
      "We should not reach this line" should == true
    } catch (Fancy StopIteration) => ex {
      ex result should == 42
    }
  }

  it: "iterates with an object" for: 'with:each: when: {
    enum = (42..45) to_enum
    result = enum with: [] each: |val, obj| { obj << val }
    result should == [42, 43, 44, 45]
  }

  it: "chunks up into enums" for: 'chunk: when: {
    enum = (1..42) to_enum
    chunked = enum chunk: |n| { n % 3 == 0 }
    chunked next should == [false, [1,2]]
    chunked next should == [true, [3]]
  }
}

# => [:each, :each_with_index, :each_with_object, :with_index, :with_object, :next_values, :peek_values, :next, :peek, :feed, :rewind, :inspect]
