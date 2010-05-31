FancySpec describe: Hash with: |it| {
  it should: "be empty on initialization" when: {
    hash = <[]>;
    hash size should_equal: 0;
    hash empty? should_equal: true
  };
  
  it should: "be empty on initialization via Hash#new" when: {
    hash = Hash new;
    hash size should_equal: 0;
    hash empty? should_equal: true
  };
  
  it should: "contain one entry" when: {
    hash = <[:foo => "bar"]>;
    hash size should_equal: 1;
    hash empty? should_equal: nil
  };

  it should: "contain 10 square values after 10 insertions" when: {
    hash = Hash new;
    10 times: |i| {
      hash at: i put: (i * i)
    };

    10 times: |i| {
      hash at: i . should_equal: (i * i)
    }
  };

  it should: "override the value for a given key" when: {
    hash = <[:foo => "bar"]>;
    hash at: :foo . should_equal: "bar";
    hash at: :foo put: :foobarbaz;
    hash at: :foo . should_equal: :foobarbaz
  };

  it should: "return all keys" when: {
    hash = <[:foo => "bar", :bar => "baz", :foobar => 112.21]>;
    hash keys should_be: |x| { x === [:foo, :bar, :foobar] }
  };

  it should: "return all values" when: {
    hash = <[:foo => "bar", :bar => "baz", :foobar => 112.21]>;
    hash values should_be: |x| { x === ["bar", "baz", 112.21] }
  };

  it should: "return value by the []-operator" when: {
    hash = <[:foo => "bar", :bar => "baz", :foobar => 112.21]>;
    hash[:foo] should_equal: "bar";
    hash[:bar] should_equal: "baz";
    hash[:foobar] should_equal: 112.21
  };

  it should: "call the Block for each key and value" when: {
    hash = <[:foo => "bar", :bar => "baz", :foobar => 112.21]>;
    hash each: |key val| {
      val should_equal: $ hash[key]
    }
  };

  it should: "call the Block with each key" when: {
    hash = <[:foo => "bar", :bar => "baz", :foobar => 112.21]>;
    count = 0;
    hash each_key: |key| {
      key should_equal: $ hash keys[count];
      count = count + 1
    }
  };

  it should: "call the Block with each value" when: {
    hash = <[:foo => "bar", :bar => "baz", :foobar => 112.21]>;
    count = 0;
    hash each_value: |val| {
      val should_equal: $ hash values[count];
      count = count + 1
    }
  };

  it should: "call most Enumerable methods with each pair" when: {
    hash = <[:hello => "world", :fancy => "is cool"]>;

    hash map: |pair| { pair[0] }
      . should_be: |arr| { arr === [:hello, :fancy] }; # order does not matter

    hash select: |pair| { pair[1] to_s include?: "c" }
      . should_equal: [[:fancy, "is cool"]];

    hash reject: |pair| { pair[0] to_s include?: "l" }
      . map: :second . should_equal: ["is cool"]
  }
}
