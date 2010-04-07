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
  }
}
