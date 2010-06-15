FancySpec describe: Array with: |it| {
  it should: "contain three number values after adding them" when: {
    arr = [];
    arr << 1;
    arr << 2;
    arr << 3;
    arr should_equal: [1,2,3]
  };

  it should: "iterate over all elements, calling a block" when: {
    sum = 0;
    retval = [1,2,3,4,5] each: |x| { sum = sum + x };
    retval should_equal: sum;
    sum should_equal: $ [1,2,3,4,5] sum
  };

  it should: "be empty after clearing it" when: {
    arr = [1,2,3];
    arr size should_equal: 3;
    arr clear;
    arr size should_equal: 0
  };

  it should: "be true for empty? when it's empty" when: {
    [] empty? should_equal: true;
    [1] empty? should_equal: nil;
    [1,2] empty? should_equal: nil;
    [1,2,3] empty? should_equal: nil
  };

  it should: "be an empty array after initialization" when: {
    arr = Array new;
    arr size should_equal: 0
  };

  it should: "return the correct value via index access" when: {
    arr = [:a, 10, "hello, world"];
    arr at: 2 . should_equal: "hello, world";
    arr at: 1 . should_equal: 10;
    arr at: 0 . should_equal: :a
  };

  it should: "NOT include the items" when: {
    arr = [:a, 10, "hello, world"];
    arr include?: "hello" . should_equal: nil;
    arr include?: 11 . should_equal: nil;
    arr include?: :b . should_equal: nil
  };

  it should: "include the items" when: {
    arr = [:a, 10, "hello, world"];
    arr include?: "hello, world" . should_equal: true;
    arr include?: 10 . should_equal: true;
    arr include?: :a . should_equal: true
  };

  it should: "return the correct index (or nil) for an element" when: {
    arr = [1, 2, :a, 3, 4];
    arr index: 1 . should_equal: 0;
    arr index: 2 . should_equal: 1;
    arr index: :a . should_equal: 2;
    arr index: 3 . should_equal: 3;
    arr index: 4 . should_equal: 4;
    arr index: :foo . should_equal: nil
  };

  it should: "return an Array of all its indices" when : {
    [:foo, :bar, :baz] indices should_equal: [0,1,2];
    [] indices should_equal: [];
    [:foo] indices should_equal: [0]
  };

  it should: "return all indices for an element as an Array" when: {
    arr = [1, 2, :a, 3, 2, :a];
    arr indices: 1 . should_equal: [0];
    arr indices: 2 . should_equal: [1, 4];
    arr indices: :a . should_equal: [2, 5];
    arr indices: 3. should_equal: [3];
    arr indices: :foo . should_equal: []
  };
  
  it should: "find the value" when: {
    arr = [:foo, "bar", :baz, 1234];

    arr find: "bar" . should_equal: "bar";

    arr find: |x| {
      x is_a?: String . if_true: {
        x from: 0 to: 1 == "ba"
      }
    } . should_equal: "bar";
    
    arr find: "foo" . should_equal: nil
  };

  it should: "NOT find the value" when: {
    arr = [:foo, "bar", :baz, 1234];

    arr find: "ba" . should_equal: nil;

    arr find: |x| {
      x is_a?: String . if_true: {
        x from: 0 to: 1 == "aa"
      }
    } . should_equal: nil;
    
    arr find: "foobar" . should_equal: nil
  };

  it should: "return the last element" when: {
    arr = [1, 2, 3, :foo, "bar"];
    arr last should_equal: "bar";
    (arr last == :foo) should_equal: nil
  };

  it should: "return the last n element" when: {
    arr = [1, 2, 3, :foo, "bar"];
    arr last: 1 . should_equal: [arr last];
    arr last: 2 . should_equal: [:foo, "bar"];
    arr last: 3 . should_equal: [3, :foo, "bar"];
    arr last: 4 . should_equal: [2, 3, :foo, "bar"];
    arr last: 5 . should_equal: [1, 2, 3, :foo, "bar"];
    arr last: (arr size) . should_equal: arr;
    arr last: (arr size + 1) . should_equal: []
  };
  
  it should: "return an array containing the values at the given indices" when: {
    arr = [1, 2, 3, :foo, "bar"];
    arr values_at: [1, 3, 4, 10] . should_equal: [2, :foo, "bar", nil]
  };

  it should: "return unique values only" when: {
    arr = [:foo, :bar, "baz", :foo, "baz", "hello", 1, 0, 0, 1, :bar, :foo, "hello"];
    arr uniq should_equal: [:foo, :bar, "baz", "hello", 1, 0]
  };

  it should: "prepend self to another array" when: {
    arr1 = [:foo, :bar, :baz];
    arr2 = [1, 2, 3];
    (arr1 >> arr2) should_equal: [:foo, :bar, :baz, 1, 2, 3]
  };
  
  it should: "get an element by the []-operator" when: {
    arr = [:foo, :bar, :baz];
    arr[0] should_equal: :foo;
    arr[1] should_equal: :bar;
    arr[2] should_equal: :baz
  };

  it should: "get a sub-array by the []-operator" when: {
    arr = [:foo, :bar, :baz];
    arr[[0,2]] should_equal: arr;
    arr[[0,1]] should_equal: [:foo, :bar];
    arr[[0,1]] should_equal: (arr from: 0 to: 1);
    arr[[0,0]] should_equal: [arr[0]];
    arr[[1,1]] should_equal: [arr[1]];
    arr[[2,2]] should_equal: [arr[2]];
    arr[[0,-1]] should_equal: arr;
    arr[[-1,-1]] should_equal: [arr last];
    arr[[-2,-1]] should_equal: [:bar, :baz];
    arr[[-2,-1]] should_equal: (arr last: 2)
  };

  it should: "join all elements with a string to a new string" when: {
    arr = [:foo, :bar, :baz];
    arr join: "," . should_equal: "foo,bar,baz"
  };

  it should: "join all elements with the empty string to a new string" when: {
    arr = [:foo, :bar, :baz];
    arr join should_equal: "foobarbaz"
  };

  it should: "remove an element at a given index" when: {
    arr = [1, :foo, 2, :bar, 3, :baz];
    # remove_at: returns the removed element
    arr remove_at: 1 . should_equal: :foo;
    arr should_equal: [1, 2, :bar, 3, :baz];
    arr remove_at: 3;
    arr should_equal: [1, 2, :bar, :baz];
    arr remove_at: [2, 3];
    arr should_equal: [1, 2];
    arr = [1, :hello, 2, :world];
    # remove_at: returns the removed elements as an array
    # if it was passed an array of indexes
    arr remove_at: [0, 2, 3] . should_equal: [1, 2, :world];
    arr should_equal: [:hello]
  };

  it should: "remove all occurances of a given object in-place" when: {
    arr = [1, 2, :foo, 3, :foo, 2, 4];
    arr remove: 2;
    arr should_equal: [1, :foo, 3, :foo, 4];
    arr remove: :foo;
    arr should_equal: [1, 3, 4]
  };

  it should: "remove all elements with the given Array of indices" when: {
    arr = [1, 2, :foo, 3, :foo, 2, 4];
    arr remove_at: [0, 2, 4];
    arr should_equal: [2, 3, 2, 4]
  };

  it should: "remove all elements that meet a given condition block" when: {
    arr = [1, 2, 3, 2, 5, 4];
    arr remove_if: |x| { x < 3 };
    arr should_equal: [3, 5, 4]
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
  };

  it should: "remove all values that meet a condition" when: {
    arr = [:foo, :bar, 1, 2, :baz, "hello"];
    arr reject!: |x| { x is_a?: String } . should_equal: [:foo, :bar, 1, 2, :baz];
    arr should_equal: [:foo, :bar, 1, 2, :baz];
    arr reject!: |x| { x is_a?: Number };
    arr should_equal: [:foo, :bar, :baz]
  };

  it should: "remove all values that don't meet a condition" when: {
    arr = [:foo, :bar, 1, 2, :baz, "hello"];
    arr select!: |x| { x is_a?: Number };
    arr should_equal: [1, 2]
  };

  it should: "return a new Array with all elements that meet a given condition" when: {
    arr = [1, 2, "foo", :bar, 120];
    arr select: |x| { x is_a?: Number } . should_equal: [1,2,120];
    arr should_equal: [1, 2, "foo", :bar, 120] # select: is non-destructive
  };

  it should: "print the maximum value in the list" when: {
    [1,2,3,4] max should_equal: 4;
    [1,5,-3,2,6,-4,-2] max should_equal: 6
  };

  it should: "print the minimum value in the list" when: {
    [1,2,3,4] min should_equal: 1;
    [1,5,-3,2,6,-4,-2] min should_equal: -4
  };

  it should: "return an Array containing the elements n times." when: {
    [1,2,3,4,5] * 2 should_equal: [1,2,3,4,5,1,2,3,4,5];
    [1,2,3] * 2 should_equal: ([1,2,3] + [1,2,3])
  };

  it should: "return the concatenation of two Arrays" when: {
    ([1,2,3,4] + [-1,-2,-3,-4]) should_equal: [1,2,3,4,-1,-2,-3,-4]
  };

  it should: "return true for all elements" when: {
    [1,2,3,4] all?: |x| { x < 5 } . should_equal: true;
    [1,2,3,4] all?: |x| { x > 0 } . should_equal: true;
    [1,2,3,4] all?: |x| { x > 4 } . should_equal: nil
  };

  it should: "return true for any elements" when: {
    [1,2,3,4] any?: |x| { x > 3 } . should_equal: true;
    [1,2,3,4] any?: |x| { x < 4 } . should_equal: true;
    [1,2,3,4] any?: |x| { x > 4 } . should_equal: nil
  };

  it should: "be selected from it with each index" when: {
    ["yooo",2,3,1,:foo,"bar"] select_with_index: |x i| { x is_a?: Number } . should_equal: [[2,1], [3,2], [1,3]]
  }
}
