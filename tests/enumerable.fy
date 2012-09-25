FancySpec describe: Fancy Enumerable with: {
  it: "selects the right element based on a comparison Block and an optional selection Block" with: 'superior_by:taking: when: {
    [1,2,3,4,5] superior_by: '> . is: 5
    [1,2,3,4,5] superior_by: '< . is: 1
    [[1,2], [2,3,4], [], [1]] superior_by: '> taking: 'size . is: [2,3,4]
    [[1,2], [2,3,4], [-1]] superior_by: '< taking: 'first . is: [-1]
  }

  it: "chain-maps all blocks on all values" with: 'map_chained: when: {
    (1,2,3) map_chained: ('doubled, 'squared, 'to_s) . is: ["4", "16", "36"]
    (1,2,3) map_chained: (@{ + 1 }, 'to_s) . is: ["2", "3", "4"]
    [] map_chained: ('class, 'name) . is: []
    [1, "foo", 'hello] map_chained: ('class, 'name) . is: ["Fixnum", "String", "Symbol"]
  }

  it: "maps over its elements with their index" with: 'map_with_index: when: {
    (1,2,3) map_with_index: |x i| {
      x + i
    } . is: [1,3,5]

    [1,2,3,4] map_with_index: |x i| {
      i
    } . is: [0,1,2,3]

    [] map_with_index: |x i| { i } . is: []
  }

  it: "counts the amount of elements for which a block yields true" with: 'count: when: {
    [1,2,3] count: @{ even? } . is: 1
    (0..10) count: @{ even? } . is: 6
    (0..10) count: @{ odd? } . is: 5
    "foo" count: @{ == "o" } . is: 2
    "foo" count: @{ != "o" } . is: 1
    (1,2,3) count: @{ < 2 } . is: 1
    [] count: { true } . is: 0
    [1] count: { true } . is: 1
    [1] count: { false } . is: 0
  }

  it: "returns a string concatenation of all elements in self" with: 'to_s when: {
    (1,2,3) to_s is: "123"
    [1,2,3] to_s is: "123"
    "foo" to_s is: "foo"
    [] to_s is: ""

    class MyCollection {
      def each: block {
        (0..5) each: block
      }
      include: Fancy Enumerable
    }
    MyCollection new to_s is: "012345"
  }

  it: "returns the array in groups of 3" with: 'in_groups_of: when: {
    ['a,'b,'c] in_groups_of: 1 . is: [['a],['b],['c]]
    array = 1 upto: 10
    array in_groups_of: 3 . is: [[1,2,3], [4,5,6], [7,8,9], [10]]

    (20,30,40) in_groups_of: 2 . is: [[20,30], [40]]

    [1,2,3] in_groups_of: -1 . is: []
    [1,2,3] in_groups_of: 0 . is: []
    [1,2,3] in_groups_of: 1 . is: [[1],[2],[3]]

    [] in_groups_of: -1 . is: []
    [] in_groups_of: 0 . is: []
    [] in_groups_of: 1 . is: []
  }

  it: "indicates if it's sorted" with: 'sorted? when: {
    [] sorted? is: true
    [1] sorted? is: true
    [1,2] sorted? is: true
    [2,1] sorted? is: false

    (1,2,3) sorted? is: true
    (1,3,2) sorted? is: false

    "" sorted? is: true
    "a" sorted? is: true
    "abc" sorted? is: true
    "fabc" sorted? is: false
  }

  it: "splits a collection at an index" with: 'split_at: when: {
    [] split_at: 0 . is: [[],[]]
    [1] split_at: 0 . is: [[],[1]]
    [1] split_at: 1 . is: [[1],[]]

    (1,2,3) split_at: 1 . is: [[1], [2,3]]
    (1,2,3) split_at: 2 . is: [[1,2], [3]]

    "foo" split_at: 1 . is: [["f"], ["o", "o"]]
  }

  it: "splits a collection based on a predicate block" with: 'split_with: when: {
    [] split_with: @{ true } . is: [[],[]]
    [] split_with: @{ false } . is: [[],[]]
    [1] split_with: @{ true } . is: [[1], []]
    [1] split_with: @{ false } . is: [[], [1]]
    [1,2,3] split_with: @{ < 2 } . is: [[1], [2,3]]
    [1,2,3] split_with: @{ <= 2 } . is: [[1,2], [3]]

    "" split_with: @{ true } . is: [[], []]
    "a" split_with: @{ true } . is: [["a"], []]
    "a" split_with: @{ false } . is: [[], ["a"]]
    "abcde" split_with: @{ <= "c" } . is: [["a", "b", "c"], ["d", "e"]]
  }

  it: "takes elements from itself as long a block yields true" with: 'take_while: when: {
    (1..15) take_while: |x| { x < 10 } . is: (1 upto: 9)
  }

  it: "drops elements from itself as long a block yields true" with: 'drop_while: when: {
    (1..15) drop_while: |x| { x < 10 } . is: (10 upto: 15)
  }

  it: "returns the first n elements" with: 'first: when: {
    (1,2,3) first: 0 . is: []
    (1,2,3) first: 1 . is: [1]
    (1,2,3) first: 2 . is: [1,2]
    (1,2,3) first: 3 . is: [1,2,3]
    (1,2,3) first: 4 . is: [1,2,3]
  }

  it: "returns the last n elements" with: 'last: when: {
    (1,2,3) last: 0 . is: []
    (1,2,3) last: 1 . is: [3]
    (1,2,3) last: 2 . is: [2,3]
    (1,2,3) last: 3 . is: [1,2,3]
    (1,2,3) last: 4 . is: [1,2,3]
  }

  it: "returns the elements for which a pattern matches" with: 'grep: when: {
    "hello world" grep: /[a-h]/ . is: ["h", "e", "d"]
    ["hello", "world", 1, 2, 3] grep: String . is: ["hello", "world"]
    (1,2,3,4,5) grep: @{ < 2 } . is: [1] # blocks can be used as patterns, too :)
    (1,2,3) grep: String . is: []
    (1,2,3,4) grep: (2..3) . is: [2, 3]
  }

  it: "returns the values of calling a block for all elements for which a pattern matches" with: 'grep:taking: when: {
    "hello world" grep: /[a-h]/ taking: 'upcase . is: ["H", "E", "D"]
    ["hello", "world", 1, 2, 3] grep: String taking: 'upcase . is: ["HELLO", "WORLD"]
    (1,2,3,4,5) grep: @{ < 2 } taking: 'doubled . is: [2]
    (1,2,3) grep: String taking: 'to_s . is: []
    (1,2,3,4) grep: (2..3) taking: 'to_s . is: ["2", "3"]
  }

  it: "joins all elements by a block" with: 'join_by: when: {
    (1,2,3) join_by: '+ . is: $ (1,2,3) sum
    ("foo", "bar", "baz") join_by: '+ . is: "foobarbaz"
    [NoMethodError, IOError, ZeroDivisionError] join_by: '>< . is: (NoMethodError >< IOError >< ZeroDivisionError)
    [NoMethodError, IOError, ZeroDivisionError] join_by: '<> . is: (NoMethodError <> IOError <> ZeroDivisionError)
  }

  it: "returns the element if found" with: 'find: when: {
    [1,2,3] tap: @{
      find: 0 . is: nil
      find: 1 . is: 1
      find: 2 . is: 2
      find: 3 . is: 3
      find: 4 . is: nil
    }
  }

  it: "calls a block with the element if found" with: 'find:do: when: {
    found = []
    [1,2,3] tap: @{
      insert = |x| { found << x }
      find: 0 do: insert
      find: 1 do: insert
      find: 2 do: insert
      find: 3 do: insert
      find: 4 do: insert
    }
    found is: [1,2,3]
  }

  it: "calls a block with the element and its index if found" with: 'find_with_index:do: when: {
    found = []
    [1,2,3] tap: @{
      insert = |x i| { found << (x,i) }
      find_with_index: 0 do: insert
      find_with_index: 1 do: insert
      find_with_index: 2 do: insert
      find_with_index: 3 do: insert
      find_with_index: 4 do: insert
    }
    found is: [(1,0), (2,1), (3,2)]
  }

  it: "returns the last index of an element or nil" with: 'last_index_of: when: {
    [] last_index_of: nil . is: nil
    [] last_index_of: 1 . is: nil
    [1,2,1,2] last_index_of: 1 . is: 2
    [1,2,1,2] last_index_of: 2 . is: 3
    [1,2,1,2] last_index_of: 3 . is: nil
  }
}