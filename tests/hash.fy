FancySpec describe: Hash with: {
  it: "is empty on initialization" with: 'empty? when: {
    hash = <[]>
    hash size is: 0
    hash empty? is: true
  }

  it: "is empty on initialization via Hash#new" with: 'size when: {
    hash = Hash new
    hash size is: 0
    hash empty? is: true
  }

  it: "contains one entry" when: {
    hash = <['foo => "bar"]>
    hash size is: 1
    hash empty? is: false
  }

  it: "contains 10 square values after 10 insertions" with: 'at: when: {
    hash = Hash new
    10 times: |i| {
      hash at: i put: (i * i)
    }

    10 times: |i| {
      hash at: i . is: (i * i)
    }
  }

  it: "overrides the value for a given key" with: 'at: when: {
    hash = <['foo => "bar"]>
    hash at: 'foo . is: "bar"
    hash at: 'foo put: 'foobarbaz
    hash at: 'foo . is: 'foobarbaz
  }

  it: "calls the block if it can't find the key" with: 'at:else: when: {
    hash = <['foo => "bar", 'bar => nil]>
    hash at: 'foo else: { "hello" } . is: "bar"
    hash at: 'bar else: { "hello" } . is: nil
    hash at: 'foo1 else: { "hello" } . is: "hello"
  }

  it: "calls the block if it can't find the key and inserts the return value" with: 'at:else_put: when: {
    hash = <['foo => "bar", 'bar => nil]>
    hash at: 'foo else_put: { "hello" } . is: "bar"
    hash at: 'bar else_put: { "hello" } . is: nil
    hash at: 'foo1 else_put: { "hello" } . is: "hello"
    hash['foo1] is: "hello"
  }

  it: "returns all keys" with: 'keys when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    hash keys is =? ['foo, 'bar, 'foobar]
  }

  it: "returns all values" with: 'values when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    hash values is =? ["bar", "baz", 112.21]
  }

  it: "returns value by the []-operator" with: '[] when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    hash['foo] is: "bar"
    hash['bar] is: "baz"
    hash['foobar] is: 112.21
  }

  it: "returns nil if the key isn't defined" with: '[] when: {
    <['foo => "bar"]> ['bar] . is: nil
    <[]> ['foobar] . is: nil
    <['foo => "bar"]> [nil] . is: nil
  }

  it: "calls the Block for each key and value" with: 'each: when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    hash each: |key val| {
      val is: (hash[key])
    }
  }

  it: "calls the Block with each key" with: 'each_key: when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    count = 0
    hash each_key: |key| {
      key is: (hash keys[count])
      count = count + 1
    }
  }

  it: "calls the Block with each value" with: 'each_value: when: {
    hash = <['foo => "bar", 'bar => "baz", 'foobar => 112.21]>
    count = 0
    hash each_value: |val| {
      val is: (hash values[count])
      count = count + 1
    }
  }

  it: "calls Enumerable methods with each pair" when: {
    hash = <['hello => "world", 'fancy => "is cool"]>

    hash map: |pair| { pair[0] } . is =? ['hello, 'fancy] # order does not matter

    hash select: |pair| { pair[1] to_s includes?: "c" } .
      is: [['fancy, "is cool"]]

    hash reject: |pair| { pair[0] to_s includes?: "l" } .
      map: 'second . is: ["is cool"]
  }

  it: "returns an Array of the key-value pairs" with: 'to_a when: {
    <['foo => "bar", 'bar => "baz"]> to_a is =? [['foo, "bar"], ['bar, "baz"]]
  }

  it: "returns multiple values if given an array of keys" with: '[] when: {
    hash = <['foo => 1, 'bar => "foobar", 'baz => 42, "hello world" => "hello!"]>
    a, b, c = hash values_at: ('foo, 'bar, "hello world")
    a is: 1
    b is: "foobar"
    c is: "hello!"
  }

  it: "includes a key" with: 'includes?: when: {
    h = <['foo => "bar", 'bar => "baz"]>
    h includes?: 'foo . is: true
    h includes?: 'bar . is: true
    h includes?: "foo" . is: false
    h includes?: "bar" . is: false
    h includes?: nil . is: false
  }

  it: "returns an object with slots based on key-value pairs in Hash" with: 'to_object when: {
    <[]> to_object slots empty? is: true
    <['name => "Chris"]> to_object tap: @{
      slots is: ['name]
      name is: "Chris"
      name: "New Name"
      name is: "New Name"
    }
    <['a => "hello", 'b => "world"]> to_object tap: @{
      slots size is: 2
      slots includes?: 'a . is: true
      slots includes?: 'b . is: true
      a is: "hello"
      b is: "world"
      a: "world"
      b: "hello"
      a is: "world"
      b is: "hello"
    }
  }

  it: "returns a hash with all entries for which a block yields true" with: 'select_keys: when: {
    <[]> select_keys: { true } . is: <[]>
    <[]> select_keys: { false } . is: <[]>
    <['hello => "world"]> select_keys: { true } . is: <['hello => "world"]>
    <['hello => "world"]> select_keys: { false } . is: <[]>
    <['hello => "world", "world" => 'hello]> select_keys: @{ is_a?: Symbol } . is: <['hello => "world"]>
    <[5 => 1, 4 => 2, 3 => 3, 2 => 4, 1 => 5]> select_keys: @{ <= 3 } . is: <[1 => 5, 2 => 4, 3 => 3]>
  }

  it: "returns a hash with all entries for which a block yields false" with: 'reject_keys: when: {
    <[]> reject_keys: { true } . is: <[]>
    <[]> reject_keys: { false } . is: <[]>
    <['hello => "world"]> reject_keys: { true } . is: <[]>
    <['hello => "world"]> reject_keys: { false } . is: <['hello => "world"]>
    <['hello => "world", "world" => 'hello]> reject_keys: @{ is_a?: Symbol } . is: <["world" => 'hello]>
    <[5 => 1, 4 => 2, 3 => 3, 2 => 4, 1 => 5]> reject_keys: @{ <= 3 } . is: <[5 => 1, 4 => 2]>
  }
}
