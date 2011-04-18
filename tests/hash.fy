FancySpec describe: Hash with: {
  it: "should be empty on initialization" for: 'empty? when: {
    hash = <[]>
    hash size should == 0
    hash empty? should == true
  }

  it: "should be empty on initialization via Hash#new" for: 'size when: {
    hash = Hash new
    hash size should == 0
    hash empty? should == true
  }

  it: "should contain one entry" when: {
    hash = <['foo => "bar"]>
    hash size should == 1
    hash empty? should == false
  }

  it: "should contain 10 square values after 10 insertions" for: 'at: when: {
    hash = Hash new
    10 times: |i| {
      hash at: i put: (i * i)
    }

    10 times: |i| {
      hash at: i . should == (i * i)
    }
  }

  it: "should override the value for a given key" for: 'at: when: {
    hash = <['foo => "bar"]>
    hash at: 'foo . should == "bar"
    hash at: 'foo put: 'foobarbaz
    hash at: 'foo . should == 'foobarbaz
  }

  it: "should return all keys" for: 'keys when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    hash keys should =? ['foo, 'bar, 'foobar]
  }

  it: "should return all values" for: 'values when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    hash values should =? ["bar", "baz", 112.21]
  }

  it: "should return value by the []-operator" for: "[]" when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    hash['foo] should == "bar"
    hash['bar] should == "baz"
    hash['foobar] should == 112.21
  }

  it: "should return nil if the key isn't defined" for: '[] when: {
    <['foo => "bar"]> ['bar] . should == nil
    <[]> ['foobar] . should == nil
    <['foo => "bar"]> [nil] . should == nil
  }

  it: "should call the Block for each key and value" for: 'each: when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    hash each: |key val| {
      val should == (hash[key])
    }
  }

  it: "should call the Block with each key" for: 'each_key: when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    count = 0
    hash each_key: |key| {
      key should == (hash keys[count])
      count = count + 1
    }
  }

  it: "should call the Block with each value" for: 'each_value: when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    count = 0
    hash each_value: |val| {
      val should == (hash values[count])
      count = count + 1
    }
  }

  it: "should call most Enumerable methods with each pair" when: {
    hash = <['hello => "world", 'fancy => "is cool"]>

    hash map: |pair| { pair[0] } . should =? ['hello, 'fancy] # order does not matter

    hash select: |pair| { pair[1] to_s includes?: "c" } .
      should == [['fancy, "is cool"]]

    hash reject: |pair| { pair[0] to_s includes?: "l" } .
      map: 'second . should == ["is cool"]
  }

  it: "should return an Array of the key-value pairs" for: 'to_a when: {
    <['foo => "bar", 'bar => "baz"]> to_a should =? [['foo, "bar"], ['bar, "baz"]]
  }
}
