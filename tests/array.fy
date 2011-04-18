FancySpec describe: Array with: {
  it: "should contain three number values after adding them" for: '<< when: {
    arr = []
    arr << 1
    arr << 2
    arr << 3
    arr should == [1,2,3]
    arr size should == 3
  }

  it: "should iterate over all elements, calling a block" for: 'each: when: {
    sum = 0
    retval = [1,2,3,4,5] each: |x| { sum = sum + x }
    retval should == sum
    sum should == ([1,2,3,4,5] sum)
  }

  it: "should be empty after clearing it" for: 'clear when: {
    arr = [1,2,3]
    arr size should == 3
    arr should == [1,2,3]
    arr clear
    arr size should == 0
    arr should == []
  }

  it: "should be true for empty? when it's empty" for: 'empty? when: {
    [] empty? should == true
    [1] empty? should == false
    [1,2] empty? should == false
    [1,2,3] empty? should == false
  }

  it: "should be an empty array after initialization" for: 'new when: {
    arr = Array new
    arr size should == 0
  }

  it: "should return the correct value via index access" for: 'at: when: {
    arr = ['a, 10, "hello, world"]
    arr at: 2 . should == "hello, world"
    arr at: 1 . should == 10
    arr at: 0 . should == 'a
  }

  it: "should NOT include the items" for: "includes?:" when: {
    arr = ['a, 10, "hello, world"]
    arr includes?: "hello" . should == false
    arr includes?: 11 . should == false
    arr includes?: 'b . should == false
  }

  it: "should include the items" for: 'includes?: when: {
    arr = ['a, 10, "hello, world"]
    arr includes?: "hello, world" . should == true
    arr includes?: 10 . should == true
    arr includes?: 'a . should == true
  }

  it: "should return the correct index (or nil) for an element" for: 'index: when: {
    arr = [1, 2, 'a, 3, 4]
    arr index: 1 . should == 0
    arr index: 2 . should == 1
    arr index: 'a . should == 2
    arr index: 3 . should == 3
    arr index: 4 . should == 4
    arr index: 'foo . should == nil
  }

  it: "should return an Array of all its indices" for: 'indices when: {
    ['foo, 'bar, 'baz] indices should == [0,1,2]
    [] indices should == []
    ['foo] indices should == [0]
  }

  it: "should return all indices for an element as an Array" for: 'indices: when: {
    arr = [1, 2, 'a, 3, 2, 'a]
    arr indices_of: 1 . should == [0]
    arr indices_of: 2 . should == [1, 4]
    arr indices_of: 'a . should == [2, 5]
    arr indices_of: 3. should == [3]
    arr indices_of: 'foo . should == []
  }

  it: "should find the value" for: 'find: when: {
    arr = ['foo, "bar", 'baz, 1234]

    arr find: "bar" . should == "bar"

    arr find: |x| {
      x is_a?: String . if_true: {
        x from: 0 to: 1 == "ba"
      }
    } . should == "bar"

    arr find: "foo" . should == nil
  }

  it: "should NOT find the value" for: 'find: when: {
    arr = ['foo, "bar", 'baz, 1234]

    arr find: "ba" . should == nil

    arr find: |x| {
      x is_a?: String . if_true: {
        x from: 0 to: 1 == "aa"
      }
    } . should == nil

    arr find: "foobar" . should == nil
  }

  it: "should find the value via a block" for: 'find_by: when: {
    arr = [1, 2, 'foo, "yo", nil, true]
    arr find_by: |x| { x is_a?: String } . should == "yo"
    arr find_by: |x| { x is_a?: Block } . should == nil
  }

  it: "should return the last element" for: 'last when: {
    arr = [1, 2, 3, 'foo, "bar"]
    arr last should == "bar"
    (arr last == 'foo) should == false
  }

  it: "should return the last n element" for: 'last: when: {
    arr = [1, 2, 3, 'foo, "bar"]
    arr last: 1 . should == [arr last]
    arr last: 2 . should == ['foo, "bar"]
    arr last: 3 . should == [3, 'foo, "bar"]
    arr last: 4 . should == [2, 3, 'foo, "bar"]
    arr last: 5 . should == [1, 2, 3, 'foo, "bar"]
    arr last: (arr size) . should == arr
    arr last: (arr size + 1) . should == arr
  }

  it: "should return an array containing the values at the given indices" for: 'values_at: when: {
    arr = [1, 2, 3, 'foo, "bar"]
    arr values_at: [1, 3, 4, 10] . should == [2, 'foo, "bar", nil]
  }

  it: "should return unique values only" for: 'uniq when: {
    arr = ['foo, 'bar, "baz", 'foo, "baz", "hello", 1, 0, 0, 1, 'bar, 'foo, "hello"]
    arr uniq should == ['foo, 'bar, "baz", "hello", 1, 0]
  }

  it: "should prepend self to another array" for: '>> when: {
    arr1 = ['foo, 'bar, 'baz]
    arr2 = [1, 2, 3]
    (arr1 >> arr2) should == ['foo, 'bar, 'baz, 1, 2, 3]
  }

  it: "should get an element by the []-operator" for: "[]" when: {
    arr = ['foo, 'bar, 'baz]
    arr[0] should == 'foo
    arr[1] should == 'bar
    arr[2] should == 'baz
  }

  it: "should get a sub-array by the []-operator" for: "[]" when: {
    arr = ['foo, 'bar, 'baz]
    arr[[0,2]] should == arr
    arr[[0,1]] should == ['foo, 'bar]
    arr[[0,1]] should == (arr from: 0 to: 1)
    arr[[0,0]] should == [arr[0]]
    arr[[1,1]] should == [arr[1]]
    arr[[2,2]] should == [arr[2]]
    arr[[0,-1]] should == arr
    arr[[-1,-1]] should == [arr last]
    arr[[-2,-1]] should == ['bar, 'baz]
    arr[[-2,-1]] should == (arr last: 2)
  }

  it: "should join all elements with a string to a new string" for: 'join: when: {
    arr = ['foo, 'bar, 'baz]
    arr join: "," . should == "foo,bar,baz"
  }

  it: "should join all elements with the empty string to a new string" for: 'join when: {
    arr = ['foo, 'bar, 'baz]
    arr join should == "foobarbaz"
  }

  it: "should remove an element at a given index" for: 'remove_at: when: {
    arr = [1, 'foo, 2, 'bar, 3, 'baz]
    # remove_at: returns the removed element
    arr remove_at: 1 . should == 'foo
    arr should == [1, 2, 'bar, 3, 'baz]
    arr remove_at: 3
    arr should == [1, 2, 'bar, 'baz]
    arr remove_at: [2, 3]
    arr should == [1, 2]
    arr = [1, 'hello, 2, 'world]
    # remove_at: returns the removed elements as an array
    # if it was passed an array of indexes
    arr remove_at: [0, 2, 3] . should == [1, 2, 'world]
    arr should == ['hello]
  }

  it: "should remove all occurances of a given object in-place" for: 'remove: when: {
    arr = [1, 2, 'foo, 3, 'foo, 2, 4]
    arr remove: 2
    arr should == [1, 'foo, 3, 'foo, 4]
    arr remove: 'foo
    arr should == [1, 3, 4]
  }

  it: "should remove all elements with the given Array of indices" for: 'remove_at: when: {
    arr = [1, 2, 'foo, 3, 'foo, 2, 4]
    arr remove_at: [0, 2, 4]
    arr should == [2, 3, 2, 4]
  }

  it: "should remove all elements that meet a given condition block" for: 'remove_if: when: {
    arr = [1, 2, 3, 2, 5, 4]
    arr remove_if: |x| { x < 3 }
    arr should == [3, 5, 4]
  }

  it: "should remove all nil-value entries when calling compact" for: 'compact when: {
    ['foo, nil, 'bar, nil, 'baz] compact should == ['foo, 'bar, 'baz]
    [] compact should == []
    [nil] compact should == []
    ['foo] compact should == ['foo]
  }

  it: "should remove all nil-value entries in place when calling compact!" for: 'compact! when: {
    arr = ['foo, nil, 'bar, nil, 'baz]
    arr compact! should == ['foo, 'bar, 'baz]
    arr should == ['foo, 'bar, 'baz]
    [] compact! should == []
    [nil] compact! should == []
    ['foo] compact! should == ['foo]
  }

  it: "should remove all values that meet a condition" for: 'reject!: when: {
    arr = ['foo, 'bar, 1, 2, 'baz, "hello"]
    arr reject!: |x| { x is_a?: String } . should == ['foo, 'bar, 1, 2, 'baz]
    arr should == ['foo, 'bar, 1, 2, 'baz]
    arr reject!: |x| { x is_a?: Fixnum }
    arr should == ['foo, 'bar, 'baz]
  }

  it: "should remove all values that don't meet a condition" for: 'select!: when: {
    arr = ['foo, 'bar, 1, 2, 'baz, "hello"]
    arr select!: |x| { x is_a?: Fixnum }
    arr should == [1, 2]
  }

  it: "should return a new Array with all elements that meet a given condition" for: 'select: when: {
    arr = [1, 2, "foo", 'bar, 120]
    arr select: |x| { x is_a?: Fixnum } . should == [1,2,120]
    arr should == [1, 2, "foo", 'bar, 120] # select: is non-destructive
  }

  it: "should print the maximum value in the list" for: 'max when: {
    [1,2,3,4] max should == 4
    [1,5,-3,2,6,-4,-2] max should == 6
  }

  it: "should print the minimum value in the list" for: 'min when: {
    [1,2,3,4] min should == 1
    [1,5,-3,2,6,-4,-2] min should == -4
  }

  it: "should return an Array containing the elements n times." for: '* when: {
    [1,2,3,4,5] * 2 should == [1,2,3,4,5,1,2,3,4,5]
    [1,2,3] * 2 should == ([1,2,3] + [1,2,3])
    ['a,'b,'c] * 4 should == ['a,'b,'c, 'a,'b,'c, 'a,'b,'c, 'a,'b,'c]
  }

  it: "should return the concatenation of two Arrays" for: '+ when: {
    ([1,2,3,4] + [-1,-2,-3,-4]) should == [1,2,3,4,-1,-2,-3,-4]
  }

  it: "should return true for all elements" for: 'all?: when: {
    [1,2,3,4] all?: |x| { x < 5 } . should == true
    [1,2,3,4] all?: |x| { x > 0 } . should == true
    [1,2,3,4] all?: |x| { x > 4 } . should == false
  }

  it: "should return true for any elements" for: 'any?: when: {
    [1,2,3,4] any?: |x| { x > 3 } . should == true
    [1,2,3,4] any?: |x| { x < 4 } . should == true
    [1,2,3,4] any?: |x| { x > 4 } . should == false
  }

  it: "should be selected from it with each index" for: 'select_with_index: when: {
    ["yooo",2,3,1,'foo,"bar"] select_with_index: |x i| { x is_a?: Fixnum } . should == [[2,1], [3,2], [1,3]]
  }

  it: "should return its remaining (all but the first) elements as a new Array" for: 'rest when: {
    [1,2,3,4] rest should == [2,3,4]
    [] rest should == []
    100 upto: 1000 . rest should == (101 upto: 1000)
  }

  it: "should return itself as a string" for: 'to_s when: {
    [1,2,3] to_s should == "123"
  }

  it: "should call a given block between calling the each block" for: 'each:in_between: when: {
    arr = []
    [1,2,3] each: |x| { arr << x } in_between: { arr << "-" }
    arr should == [1, "-", 2, "-", 3]

    str = ""
    ['foo, 'bar, 'baz] each: |x| { str = str ++ (x to_s) } in_between: { str = str ++ " " }
    str should == "foo bar baz"
  }

  it: "should return the reduced value for a given block and initial value" for: 'reduce:init_val: when: {
    arr = 1 upto: 10
    arr sum should == (arr reduce: '+ init_val: 0)
    arr product should == (arr reduce: '* init_val: 1)
    arr to_s should == (arr reduce: '++ init_val: "")
  }

  it: "should return the reverse of itself" for: 'reverse when: {
    [1,2,3] reverse should == [3,2,1]
    1 upto: 10 . reverse should == (10 downto: 1)
  }

  it: "should inverse in-place" for: 'reverse! when: {
    arr = [1,2,3]
    arr reverse! should == [3,2,1]
    arr should == [3,2,1]
  }

  it: "should take elements from itself as long a block yields true" for: 'take_while: when: {
    1 upto: 15 . take_while: |x| { x < 10 } . should == (1 upto: 9)
  }


  it: "should drop elements from itself as long a block yields true" for: 'drop_while: when: {
    1 upto: 15 . drop_while: |x| { x < 10 } . should == (10 upto: 15)
  }

  it: "should partition an array via a given block" for: 'partition_by: when: {
    arr = [1,2,2,3,3,3,4,4,4,4,5]
    arr partition_by: 'identity . should == [[1], [2,2], [3,3,3], [4,4,4,4], [5]]
    arr partition_by: @{== 2} . should == [[1], [2,2], [3,3,3,4,4,4,4,5]]
  }

  it: "should remove the first value" for: 'shift when: {
    a = [1,2,3]
    a shift should == 1
    a should == [2,3]

    a = []
    a shift should == nil
    a should == []
  }

  it: "should append a value at the front" for: 'unshift: when: {
    a = []
    a unshift: 1 . should == a # should return self
    a should == [1]

    a = [1,2,3]
    a unshift: (a shift) . should == a
    a should == [1,2,3]
  }
}
