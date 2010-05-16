FancySpec describe: Array with: |it| {
  it should: "contain three number values after adding them" when: {
    @arr = [];
    @arr << 1;
    @arr << 2;
    @arr << 3;
    @arr should_equal: [1,2,3]
  };

  it should: "be empty after clearing it" when: {
    @arr = [1,2,3];
    @arr size should_equal: 3;
    @arr clear;
    @arr size should_equal: 0
  };

  it should: "be an empty array after initialization" when: {
    @arr = Array new;
    @arr size should_equal: 0
  };

  it should: "return the correct value via index access" when: {
    @arr = [:a, 10, "hello, world"];
    @arr at: 2 . should_equal: "hello, world";
    @arr at: 1 . should_equal: 10;
    @arr at: 0 . should_equal: :a
  };

  it should: "NOT include the items" when: {
    @arr = [:a, 10, "hello, world"];
    @arr include?: "hello" . should_equal: nil;
    @arr include?: 11 . should_equal: nil;
    @arr include?: :b . should_equal: nil
  };

  it should: "include the items" when: {
    @arr = [:a, 10, "hello, world"];
    @arr include?: "hello, world" . should_equal: true;
    @arr include?: 10 . should_equal: true;
    @arr include?: :a . should_equal: true
  };

  it should: "find the value" when: {
    @arr = [:foo, "bar", :baz, 1234];

    @arr find: "bar" . should_equal: "bar";

    @arr find: |x| {
      x is_a?: String . if_true: {
        x from: 0 to: 1 == "ba"
      }
    } . should_equal: "bar";
    
    @arr find: "foo" . should_equal: nil
  };

  it should: "NOT find the value" when: {
    @arr = [:foo, "bar", :baz, 1234];

    @arr find: "ba" . should_equal: nil;

    @arr find: |x| {
      x is_a?: String . if_true: {
        x from: 0 to: 1 == "aa"
      }
    } . should_equal: nil;
    
    @arr find: "foobar" . should_equal: nil
  };

  it should: "return the last element" when: {
    @arr = [1, 2, 3, :foo, "bar"];
    @arr last should_equal: "bar";
    (@arr last == :foo) should_equal: nil
  };

  it should: "return the last n element" when: {
    @arr = [1, 2, 3, :foo, "bar"];
    @arr last: 1 . should_equal: [@arr last];
    @arr last: 2 . should_equal: [:foo, "bar"];
    @arr last: 3 . should_equal: [3, :foo, "bar"];
    @arr last: 4 . should_equal: [2, 3, :foo, "bar"];
    @arr last: 5 . should_equal: [1, 2, 3, :foo, "bar"];
    @arr last: (@arr size) . should_equal: @arr;
    @arr last: (@arr size + 1) . should_equal: []
  };
  
  it should: "return an array containing the values at the given indices" when: {
    @arr = [1, 2, 3, :foo, "bar"];
    @arr values_at: [1, 3, 4] . should_equal: [2, :foo, "bar"]
  };

  it should: "return unique values only" when: {
    @arr = [:foo, :bar, "baz", :foo, "baz", "hello", 1, 0, 0, 1, :bar, :foo, "hello"];
    @arr uniq should_equal: [:foo, :bar, "baz", "hello", 1, 0]
  };

  it should: "prepend self to another array" when: {
    arr1 = [:foo, :bar, :baz];
    arr2 = [1, 2, 3];
    (arr1 >> arr2) should_equal: [:foo, :bar, :baz, 1, 2, 3]
  };
  
  it should: "get an element by the []-operator" when: {
    arr1 = [:foo, :bar, :baz];
    arr1[0] should_equal: :foo;
    arr1[1] should_equal: :bar;
    arr1[2] should_equal: :baz
  };

  it should: "join all elements with a string to a new string" when: {
    arr = [:foo, :bar, :baz];
    arr join: "," . should_equal: "foo,bar,baz"
  };

  it should: "join all elements with the empty string to a new string" when: {
    arr = [:foo, :bar, :baz];
    arr join should_equal: "foobarbaz"
  };

  it should: "remove all nil-value entries when calling compact" when: {
    [:foo, nil, :bar, nil, :baz] compact should_equal: [:foo, :bar, :baz];
    [] compact should_equal: [];
    [nil] compact should_equal: [];
    [:foo] compact should_equal: [:foo]
  };

  it should: "remove all nil-value entries in place when calling compact!" when: {
    arr = [:foo, nil, :bar, nil, :baz];
    arr compact! should_equal: [:foo, :bar, :baz];
    arr should_equal: [:foo, :bar, :baz];
    [] compact! should_equal: [];
    [nil] compact! should_equal: [];
    [:foo] compact! should_equal: [:foo]
  }
}
