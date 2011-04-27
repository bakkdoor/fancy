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
    enum = to_enum: 'iter
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
}

# => [:each, :each_with_index, :each_with_object, :with_index, :with_object, :next_values, :peek_values, :next, :peek, :feed, :rewind, :inspect]
