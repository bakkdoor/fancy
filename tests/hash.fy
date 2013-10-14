FancySpec describe: Hash with: {
  it: "is empty on initialization" with: 'empty? when: {
    <[]> tap: @{
      size is: 0
      empty? is: true
    }
  }

  it: "is empty on initialization via Hash#new" with: 'size when: {
    Hash new tap: @{
      size is: 0
      empty? is: true
    }
  }

  it: "contains one entry" when: {
    <['foo => "bar"]> tap: @{
      size is: 1
      empty? is: false
    }
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

  it: "returns a nested object with slots based on key-value pairs in hashes" with: 'to_object_deep when: {
    hashes = [
      <[]>,
      <['name => "foo", 'age => 42]>
    ]

    hashes each: |h| {
      o = h to_object_deep
      o slots each: |s| {
        o receive_message: s . is: $ h[s]
      }
    }


    people = [
      <['person => <['name => "foo", 'age => 42, 'city => "London"]>]>,
      <['person => { name: "foo" age: 42 city: "London" }]> # even works with blocks, yay
    ]

    people each: @{
      to_object_deep tap: @{
        person name is: "foo"
        person age is: 42
        person city is: "London"
      }
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

  class HashCallable {
    read_write_slots: ('foo, 'bar)
  }

  it: "is callable, like a block" with: 'call: when: {
    hc = HashCallable new

    hc foo is: nil
    hc bar is: nil

    <['foo: => "bar", 'bar: => 123]> call: [hc] . is: hc

    hc foo is: "bar"
    hc bar is: 123

    <['foo => "foobar", 'bar => 456]> call: [hc]

    hc foo is: "foobar"
    hc bar is: 456
  }

  it: "returns itself as a block" with: 'to_block when: {
    hc = HashCallable new

    hc foo is: nil
    hc bar is: nil

    <['foo: => "hello", 'bar: => "world"]> tap: |hash| {
      block = hash to_block
      block is_a?: Block . is: true
      block arity is: 1
      block call: [hc] . is: hc
    }

    hc foo is: "hello"
    hc bar is: "world"

    <['foo => 123, 'bar => 'baz]> to_block call: [hc]

    hc foo is: 123
    hc bar is: 'baz
  }

  it: "returns a nested Hash" with: 'to_hash_deep when: {
    <[]> to_hash_deep is: <[]>
    <['foo => "bar"]> to_hash_deep is: <['foo => "bar"]>
    <['foo => {bar: "baz"}]> to_hash_deep is: <['foo => <['bar => "baz"]>]>
    <[
      'foo => {
        bar: {
          baz: "quux"
        }
      }
    ]> to_hash_deep is: <[
      'foo => <[
        'bar => <[
          'baz => "quux"
        ]>
      ]>
    ]>
  }

  it: "updates its values with a block" with: 'update_values: when: {
    <[]> update_values: @{ to_s } . is: <[]>
    h = <['name => "Tom", 'age => 21]>
    h update_values: @{ * 2 }
    h is: <['name => "TomTom", 'age => 42]>
  }

  it: "updates its keys with a block" with: 'update_keys: when: {
    <[]> update_keys: @{ to_s } . is: <[]>
    h = <['name => "Tom", 'age => 21]>
    h update_keys: @{ to_s * 2 }
    h is: <["namename" => "Tom", "ageage" => 21]>
  }

  it: "returns a new hash based on self with values updated with a block" with: 'with_updated_values: when: {
    <[]> with_updated_values: @{ * 2 } . is: <[]>
    h1 = <['name => "Tom", 'age => 21]>
    h2 = h1 with_updated_values: @{ * 2 }

    h1 is: <['name => "Tom", 'age => 21]>
    h2 is: <['name => "TomTom", 'age => 42]>
  }

  it: "returns a new hash based on self with keys updated with a block" with: 'with_updated_keys: when: {
    <[]> with_updated_keys: @{ * 2 } . is: <[]>
    h1 = <['name => "Tom", 'age => 21]>
    h2 = h1 with_updated_keys: @{ to_s * 2 }

    h1 is: <['name => "Tom", 'age => 21]>
    h2 is: <["namename" => "Tom", "ageage" => 21]>
  }

  it: "calls a block with a value for a given key, if available" with: 'with_value_for_key:do:else: when: {
    h = <['hello => "world", 1 => 2, "foo" => "barbaz"]>
    else_ran? = false
    else_block = { else_ran? = true }

    h with_value_for_key: 'hello do: @{ is: "world" } else: else_block
    h with_value_for_key: 1 do: @{ is: 2 } else: else_block
    h with_value_for_key: "foo" do: @{ "barbaz" } else: else_block

    else_ran? = false

    h with_value_for_key: "not in hash" do: {
      "should not call this block!" raise!
    } else: else_block

    else_ran? is: true
  }

  it: "sets the default value on creation" when: {
    h = Hash new: "default"
    h['key] is: "default"
    h['key]: "hallo"
    h['key] is: "hallo"
  }

  it: "sets the default value" with: 'default: when: {
    h = Hash new
    h default is: nil
    h default: "foo"
    h default is: "foo"

    block = |_ k| { k }
    h default: block
    h default is: block
  }

  it: "returns the default value" with: 'default when: {
    Hash new default is: nil
    Hash new: "foo" . default is: "foo"

    block = |h k| { k * 2 }
    Hash new: block . default is: block
    Hash new: block . tap: |h| {
      h[1] is: 2
      h["foo"] is: "foofoo"
    }
  }

  it: "returns the return value for a given key" with: 'default_for: when: {
    Hash new: 2 . tap: @{
      default_for: "foo" . is: 2
      default_for: "bar" . is: 2
    }

    Hash new: |_ k| { k * 2 } . tap: @{
      default_for: "foo" . is: "foofoo"
      default_for: 100 . is: 200
    }
  }
}
