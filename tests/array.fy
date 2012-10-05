FancySpec describe: Array with: {
  it: "contains three number values after adding them" with: '<< when: {
    arr = []
    arr << 1
    arr << 2
    arr << 3
    arr is: [1,2,3]
    arr size is: 3
  }

  it: "iterates over all elements, calling a block" with: 'each: when: {
    sum = 0
    [1,2,3,4,5] each: |x| { sum = sum + x }
    sum is: $ [1,2,3,4,5] sum
  }

  it: "iterates over all elements in reverse" with: 'reverse_each: when: {
    sum = 0
    last = 5
    count = 0
    [1,2,3,4,5] reverse_each: |x| {
      x <= last is: true
      last = x
      sum = sum + x
      count = count + 1
    }
    sum is: $ [1,2,3,4,5] sum
    count is: 5
    last is: 1
  }

  it: "iterates over all elements with their index" with: 'each_with_index: when: {
    sum = 0
    idx_sum = 0
    [10,20,30,40,50] each_with_index: |x i| {
      sum = sum + x
      idx_sum = idx_sum + i
    }
    sum is: 150
    idx_sum is: 10
  }

  it: "is empty after clearing it" with: 'clear when: {
    arr = [1,2,3]
    arr size is: 3
    arr is: [1,2,3]
    arr clear
    arr size is: 0
    arr is: []
  }

  it: "is true for empty? when it's empty" with: 'empty? when: {
    [] empty? is: true
    [1] empty? is: false
    [1,2] empty? is: false
    [1,2,3] empty? is: false
  }

  it: "is an empty array after initialization" with: 'new when: {
    arr = Array new
    arr size is: 0
  }

  it: "creates a new array with a given default value" with: 'new: when: {
    arr = Array new: 5
    arr size is: 5
    arr each: |x| {
      x is: nil
    }

    arr = Array new: 5 with: "hello"
    arr size is: 5
    arr each: |x| {
      x is: "hello"
    }

    arr = Array new: 5 with: { 2 + 3 }
    arr size is: 5
    arr each: |x| {
      x is: 5
    }
  }

  it: "returns the correct value via index access" with: 'at: when: {
    arr = ['a, 10, "hello, world"]
    arr at: 2 . is: "hello, world"
    arr at: 1 . is: 10
    arr at: 0 . is: 'a
  }

  it: "sets the value for a given index" with: '[]: when: {
    arr = [1,2,3]
    arr[0]: 10
    arr is: [10, 2, 3]
    arr[-1]: 30
    arr is: [10, 2, 30]
    arr[1]: 20
    arr is: [10,20,30]
    arr[3]: 40
    arr is: [10,20,30,40]
  }

  it: "does NOT include the items" with: 'includes?: when: {
    arr = ['a, 10, "hello, world"]
    arr includes?: "hello" . is: false
    arr includes?: 11 . is: false
    arr includes?: 'b . is: false
  }

  it: "includes the items" with: 'includes?: when: {
    arr = ['a, 10, "hello, world"]
    arr includes?: "hello, world" . is: true
    arr includes?: 10 . is: true
    arr includes?: 'a . is: true
  }

  it: "returns the correct index (or nil) for an element" with: 'index: when: {
    arr = [1, 2, 'a, 3, 4]
    arr index: 1 . is: 0
    arr index: 2 . is: 1
    arr index: 'a . is: 2
    arr index: 3 . is: 3
    arr index: 4 . is: 4
    arr index: 'foo . is: nil

    arr index: @{ is_a?: Symbol } . is: 2
    arr index: @{ is_a?: String } . is: nil
  }

  it: "returns an Array of all its indices" with: 'indices when: {
    ['foo, 'bar, 'baz] indices is: [0,1,2]
    [] indices is: []
    ['foo] indices is: [0]
  }

  it: "returns all indices for an element as an Array" with: 'indices_of: when: {
    arr = [1, 2, 'a, 3, 2, 'a]
    arr indices_of: 1 . is: [0]
    arr indices_of: 2 . is: [1, 4]
    arr indices_of: 'a . is: [2, 5]
    arr indices_of: 3. is: [3]
    arr indices_of: 'foo . is: []
  }

  it: "finds the value" with: 'find: when: {
    arr = ['foo, "bar", 'baz, 1234]

    arr find: "bar" . is: "bar"

    arr find: |x| {
      x is_a?: String . if_true: {
        x from: 0 to: 1 == "ba"
      }
    } . is: "bar"

    arr find: "foo" . is: nil
  }

  it: "does NOT find the value" with: 'find: when: {
    arr = ['foo, "bar", 'baz, 1234]

    arr find: "ba" . is: nil

    arr find: |x| {
      x is_a?: String . if_true: {
        x from: 0 to: 1 == "aa"
      }
    } . is: nil

    arr find: "foobar" . is: nil
  }

  it: "finds the value via a block" with: 'find_by: when: {
    arr = [1, 2, 'foo, "yo", nil, true]
    arr find_by: |x| { x is_a?: String } . is: "yo"
    arr find_by: |x| { x is_a?: Block } . is: nil
  }

  it: "returns the last element" with: 'last when: {
    arr = [1, 2, 3, 'foo, "bar"]
    arr last is: "bar"
    (arr last == 'foo) is: false
  }

  it: "returns the last n element" with: 'last: when: {
    arr = [1, 2, 3, 'foo, "bar"]
    arr last: 1 . is: [arr last]
    arr last: 2 . is: ['foo, "bar"]
    arr last: 3 . is: [3, 'foo, "bar"]
    arr last: 4 . is: [2, 3, 'foo, "bar"]
    arr last: 5 . is: [1, 2, 3, 'foo, "bar"]
    arr last: (arr size) . is: arr
    arr last: (arr size + 1) . is: arr
  }

  it: "returns an array containing the values at the given indices" with: 'values_at: when: {
    arr = [1, 2, 3, 'foo, "bar"]
    arr values_at: [1, 3, 4, 10] . is: [2, 'foo, "bar", nil]
  }

  it: "returns unique values only" with: 'unique when: {
    arr = ['foo, 'bar, "baz", 'foo, "baz", "hello", 1, 0, 0, 1, 'bar, 'foo, "hello"]
    arr unique is: ['foo, 'bar, "baz", "hello", 1, 0]
  }

  it: "prepends self to another array" with: '>> when: {
    arr1 = ['foo, 'bar, 'baz]
    arr2 = [1, 2, 3]
    (arr1 >> arr2) is: ['foo, 'bar, 'baz, 1, 2, 3]
  }

  it: "returns an element by the []-operator" with: '[] when: {
    arr = ['foo, 'bar, 'baz]
    arr[0] is: 'foo
    arr[1] is: 'bar
    arr[2] is: 'baz
  }

  it: "returns a sub-array by the []-operator" with: '[] when: {
    arr = ['foo, 'bar, 'baz]
    arr[[0,2]] is: arr
    arr[[0,1]] is: ['foo, 'bar]
    arr[[0,1]] is: (arr from: 0 to: 1)
    arr[[0,0]] is: [arr[0]]
    arr[[1,1]] is: [arr[1]]
    arr[[2,2]] is: [arr[2]]
    arr[[0,-1]] is: arr
    arr[[-1,-1]] is: [arr last]
    arr[[-2,-1]] is: ['bar, 'baz]
    arr[[-2,-1]] is: (arr last: 2)
    # works with any Enumerable as argument:
    arr[(0,2)] is: $ arr[[0,2]]
    arr[(1,2)] is: $ arr[[1,2]]
    arr[(0,-1)] is: $ arr[[0,-1]]
  }

  it: "joins all elements with a string to a new string" with: 'join: when: {
    arr = ['foo, 'bar, 'baz]
    arr join: "," . is: "foo,bar,baz"
  }

  it: "joins all elements with the empty string to a new string" with: 'join when: {
    arr = ['foo, 'bar, 'baz]
    arr join is: "foobarbaz"
  }

  it: "removes an element at a given index" with: 'remove_at: when: {
    arr = [1, 'foo, 2, 'bar, 3, 'baz]
    # remove_at: returns the removed element
    arr remove_at: 1 . is: 'foo
    arr is: [1, 2, 'bar, 3, 'baz]
    arr remove_at: 3
    arr is: [1, 2, 'bar, 'baz]
    arr remove_at: [2, 3]
    arr is: [1, 2]
    arr = [1, 'hello, 2, 'world]
    # remove_at: returns the removed elements as an array
    # if it was passed an array of indexes
    arr remove_at: [0, 2, 3] . is: [1, 2, 'world]
    arr is: ['hello]
  }

  it: "removes all occurances of a given object in-place" with: 'remove: when: {
    arr = [1, 2, 'foo, 3, 'foo, 2, 4]
    arr remove: 2
    arr is: [1, 'foo, 3, 'foo, 4]
    arr remove: 'foo
    arr is: [1, 3, 4]
  }

  it: "removes all elements with the given Array of indices" with: 'remove_at: when: {
    arr = [1, 2, 'foo, 3, 'foo, 2, 4]
    arr remove_at: [0, 2, 4]
    arr is: [2, 3, 2, 4]
  }

  it: "removes all elements that meet a given condition block" with: 'remove_if: when: {
    arr = [1, 2, 3, 2, 5, 4]
    arr remove_if: |x| { x < 3 }
    arr is: [3, 5, 4]
  }

  it: "removes all nil-value entries when calling compact" with: 'compact when: {
    ['foo, nil, 'bar, nil, 'baz] compact is: ['foo, 'bar, 'baz]
    [] compact is: []
    [nil] compact is: []
    ['foo] compact is: ['foo]
  }

  it: "removes all nil-value entries in place when calling compact!" with: 'compact! when: {
    arr = ['foo, nil, 'bar, nil, 'baz]
    arr compact! is: ['foo, 'bar, 'baz]
    arr is: ['foo, 'bar, 'baz]
    [] compact! is: []
    [nil] compact! is: []
    ['foo] compact! is: ['foo]
  }

  it: "removes all values that meet a condition" with: 'reject!: when: {
    arr = ['foo, 'bar, 1, 2, 'baz, "hello"]
    arr reject!: |x| { x is_a?: String } . is: ['foo, 'bar, 1, 2, 'baz]
    arr is: ['foo, 'bar, 1, 2, 'baz]
    arr reject!: |x| { x is_a?: Fixnum }
    arr is: ['foo, 'bar, 'baz]
  }

  it: "removes all values that don't meet a condition" with: 'select!: when: {
    arr = ['foo, 'bar, 1, 2, 'baz, "hello"]
    arr select!: |x| { x is_a?: Fixnum }
    arr is: [1, 2]
  }

  it: "returns a new Array with all elements that meet a given condition" with: 'select: when: {
    arr = [1, 2, "foo", 'bar, 120]
    arr select: |x| { x is_a?: Fixnum } . is: [1,2,120]
    arr is: [1, 2, "foo", 'bar, 120] # select: is non-destructive
  }

  it: "returns the maximum value in the list" with: 'max when: {
    [1,2,3,4] max is: 4
    [1,5,-3,2,6,-4,-2] max is: 6
  }

  it: "prints the minimum value in the list" with: 'min when: {
    [1,2,3,4] min is: 1
    [1,5,-3,2,6,-4,-2] min is: -4
  }

  it: "returns an Array containing the elements n times." with: '* when: {
    [1,2,3,4,5] * 2 is: [1,2,3,4,5,1,2,3,4,5]
    [1,2,3] * 2 is: ([1,2,3] + [1,2,3])
    ['a,'b,'c] * 4 is: ['a,'b,'c, 'a,'b,'c, 'a,'b,'c, 'a,'b,'c]
  }

  it: "returns the concatenation of two Arrays" with: '+ when: {
    ([1,2,3,4] + [-1,-2,-3,-4]) is: [1,2,3,4,-1,-2,-3,-4]
  }

  it: "returns all elements not in another collection" with: '- when: {
    [] - [] is: []
    [] - [0] is: []
    [1,2,3,4] - [2,4] is: [1,3]
    [1,2,3] - [1,2,3,5] is: []
    ["foo", "bar", "baz"] - ["bar"] is: ["foo", "baz"]
  }

  it: "returns true for all elements" with: 'all?: when: {
    [1,2,3,4] all?: |x| { x < 5 } . is: true
    [1,2,3,4] all?: |x| { x > 0 } . is: true
    [1,2,3,4] all?: |x| { x > 4 } . is: false
  }

  it: "returns true for any elements" with: 'any?: when: {
    [1,2,3,4] any?: |x| { x > 3 } . is: true
    [1,2,3,4] any?: |x| { x < 4 } . is: true
    [1,2,3,4] any?: |x| { x > 4 } . is: false
  }

  it: "returns its remaining (all but the first) elements as a new Array" with: 'rest when: {
    [1,2,3,4] rest is: [2,3,4]
    [] rest is: []
    100 upto: 1000 . rest is: (101 upto: 1000)
  }

  it: "returns itself as a string" with: 'to_s when: {
    [1,2,3] to_s is: "123"
  }

  it: "calls a given block between calling the each block" with: 'each:in_between: when: {
    arr = []
    [1,2,3] each: |x| { arr << x } in_between: { arr << "-" }
    arr is: [1, "-", 2, "-", 3]

    str = ""
    ['foo, 'bar, 'baz] each: |x| { str = str ++ (x to_s) } in_between: { str = str ++ " " }
    str is: "foo bar baz"
  }

  it: "returns the reduced value for a given block and initial value" with: 'reduce:init_val: when: {
    arr = 1 upto: 10
    arr sum is: (arr reduce: '+ init_val: 0)
    arr product is: (arr reduce: '* init_val: 1)
    arr to_s is: (arr reduce: '++ init_val: "")
  }

  it: "returns the reverse of itself" with: 'reverse when: {
    [1,2,3] reverse is: [3,2,1]
    1 upto: 10 . reverse is: (10 downto: 1)
  }

  it: "inverses in-place" with: 'reverse! when: {
    arr = [1,2,3]
    arr reverse! is: [3,2,1]
    arr is: [3,2,1]
  }

  it: "partitions an array via a given block" with: 'partition_by: when: {
    arr = [1,2,2,3,3,3,4,4,4,4,5]
    arr partition_by: 'identity . is: [[1], [2,2], [3,3,3], [4,4,4,4], [5]]
    arr partition_by: @{== 2} . is: [[1], [2,2], [3,3,3,4,4,4,4,5]]
  }

  it: "removes the first value" with: 'shift when: {
    a = [1,2,3]
    a shift is: 1
    a is: [2,3]

    a = []
    a shift is: nil
    a is: []
  }

  it: "appends another Array onto self" with: 'append: when: {
    a = [1,2,3]
    a append: [4,5,6] . is: a
    a is: [1,2,3,4,5,6]

    a append: []
    a is: [1,2,3,4,5,6]

    [] append: [] . is: []
    [] append: (1,2,3) . is: [1,2,3] # works with any Enumerable
  }

  it: "prepends another Array onto self" with: 'prepend: when: {
    a = [1,2,3]
    a prepend: [4,5,6]
    a is: [4,5,6,1,2,3]

    a prepend: []
    a is: [4,5,6,1,2,3]

    [] prepend: [] . is: []
    [] prepend: (1,2,3) . is: [1,2,3] # works with any Enumerable
  }

  it: "prepends a value at the front" with: 'unshift: when: {
    a = []
    a unshift: 1 . is: a # is return self
    a is: [1]

    a = [1,2,3]
    a unshift: (a shift) . is: a
    a is: [1,2,3]
  }

  it: "compares 2 arrays without regard to order" with: '=? when: {
    [1,2,3] =? [2,1,3] is: true
    [1,2,3,4] =? [2,1,4,3] is: true
    [1,2] =? [1,2,3] is: false
    [1,2] =? [2] is: false
    [2] =? [1,2] is: false
    [] =? [] is: true
    [1] =? [1] is: true
  }

  it: "returns the first element" with: 'first when: {
    [1,2] first is: 1
    [1] first is: 1
    [] first is: nil
  }

  it: "returns the second element" with: 'second when: {
    [1,2,3] second is: 2
    [1,2] second is: 2
    [1] second is: nil
    [] second is: nil
  }

  it: "returns the third element" with: 'third when: {
    [1,2,3,4] third is: 3
    [1,2,3] third is: 3
    [1,2] third is: nil
    [1] third is: nil
    [] third is: nil
  }

  it: "returns the fourth element" with: 'fourth when: {
    [1,2,3,4,5] fourth is: 4
    [1,2,3,4] fourth is: 4
    [1,2,3] fourth is: nil
    [1,2] fourth is: nil
    [1] fourth is: nil
    [] fourth is: nil
  }

  it: "returns all but the first element" with: 'rest when: {
    [1,2,3,4] rest is: [2,3,4]
    [2,3] rest is: [3]
    [1] rest is: []
    [] rest is: []
  }

  it: "returns a clone" with: 'clone when: {
    [1,2,3] clone is: [1,2,3]
    [1] clone is: [1]
    [] clone is: []
  }

  it: "calculates the sum for an Array of numbers" with: 'sum when: {
    [1,2,3] sum is: 6
    [1] sum is: 1
    [] sum is: 0
  }

  it: "calculates the product for an Array of numbers" with: 'product when: {
    [1,2,3,4] product is: 24
    [1] product is: 1
    [] product is: 1
  }

  it: "calculates the average for an Array of numbers" with: 'average when: {
    [] average is: 0
    [-1] average is: -1
    [0] average is: 0
    [1] average is: 1
    [1,2] average is: 1.5
    [1,2,3] average is: 2
    [1,2,3,4] average is: 2.5
  }

  it: "sorts the array" with: 'sort when: {
    arr = [1,5,4,2,3]
    arr sort is: [1,2,3,4,5]
    arr is: [1,5,4,2,3]
  }

  it: "sorts the array with a given comparison block" with: 'sort_by: when: {
    arr = [1,5,4,2,3]
    sorted = [1,2,3,4,5]
    arr sort_by: |a b| { a <=>  b } . is: sorted
    arr is: [1,5,4,2,3]

    arr = [(1,2), (0,1), (3,0)]
    sorted = [(3,0), (0,1), (1,2)]
    arr sort_by: |a b| { a second <=> (b second) } . is: sorted
    arr sort_by: 'second . is: sorted
  }

  it: "returns a hash" with: 'to_hash when: {
    [] to_hash is: <[]>
    [[1,2],[3,4]] to_hash is: <[1 => 2, 3 => 4]>
  }

  it: "returns a hash based on a key-block" with: 'to_hash: when: {
    [] to_hash: @{ size } . is: <[]>
    [[1,2],[3,4,5]] to_hash: @{ size } . is: <[2 => [1,2], 3 => [3,4,5]]>
  }
}
