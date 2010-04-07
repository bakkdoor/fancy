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

  it should: "NOT find the value" when: {
    @arr = [:foo, "bar", :baz, 1234];

    @arr find: "bar" . should_equal: "bar";

    @arr find: |x| {
      x is_a?: String . if_true: {
        x from: 0 to: 1 == "ba"
      }
    } . should_equal: "bar";
    
    @arr find: "foo" . should_equal: nil
  }
}
