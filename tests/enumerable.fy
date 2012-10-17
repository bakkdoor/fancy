FancySpec describe: Fancy Enumerable with: {
  it: "selects the right element based on a comparison Block and an optional selection Block" with: 'superior_by:taking: when: {
    [1,2,3,4,5] superior_by: '> . is: 5
    [1,2,3,4,5] superior_by: '< . is: 1
    [[1,2], [2,3,4], [], [1]] superior_by: '> taking: 'size . is: [2,3,4]
    [[1,2], [2,3,4], [-1]] superior_by: '< taking: 'first . is: [-1]
  }

  it: "returns an Array of mapped values" with: 'map: when: {
    [] map: 'identity . is: []
    (1,2,3) map: 'squared . is: [1,4,9]
    "foo" map: 'upcase . is: ["F", "O", "O"]
  }

  it: "returns an Array of mapped values by calling a block with each element and its index" with: 'map_with_index: when: {
    [] map_with_index: 'identity . is: []
    [1,2,3] map_with_index: |x i| { i * 2 } . is: [0,2,4]
  }

  it: "chain-maps all blocks on all values" with: 'map_chained: when: {
    (1,2,3) map_chained: ('doubled, 'squared, 'to_s) . is: ["4", "16", "36"]
    (1,2,3) map_chained: (@{ + 1 }, 'to_s) . is: ["2", "3", "4"]
    [] map_chained: ('class, 'name) . is: []
    [1, "foo", 'hello] map_chained: ('class, 'name) . is: ["Fixnum", "String", "Symbol"]
  }

  it: "maps over its elements with their index" with: 'map_with_index: when: {
    (1,2,3) map_with_index: |x i| { x + i } . is: [1,3,5]

    [1,2,3,4] map_with_index: |_ i| { i } . is: [0,1,2,3]

    [] map_with_index: |_ i| { i } . is: []
  }

  it: "returns a flattened Array of mapped values" with: 'flat_map: when: {
    [] flat_map: 'identity . is: []
    (1,2,3) flat_map: 'identity . is: [1,2,3]
    [(1,2,3), (4,5,6)] flat_map: 'sum . is: [6, 15]
    [[1,2,3], [4,5,6]] flat_map: 'identity . is: [1,2,3,4,5,6]
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

  it: "calls a block with an element and its indexes" with: 'for_every:with_index_do: when: {
    found = []
    [1,2,3,2,1] tap: @{
      insert = |x i| { found << (x,i) }
      for_every: 0 with_index_do: insert
      for_every: 1 with_index_do: insert
      for_every: 2 with_index_do: insert
      for_every: 3 with_index_do: insert
      for_every: 4 with_index_do: insert
    }
    found is: [(1,0), (1,4), (2,1), (2,3), (3,2)]
  }

  it: "calls a block with an element for every occurance" with: 'for_every:do: when: {
    arr = [1,2,3,2,1]

    c = 0
    arr for_every: 0 do: { c = c + 1 }
    c is: 0

    arr for_every: 1 do: { c = c + 1 }
    c is: 2

    c = 0
    arr for_every: 2 do: { c = c + 1 }
    c is: 2

    c = 0
    arr for_every: 2 do: { c = c + 1 }
    c is: 2

    c = 0
    arr for_every: 3 do: { c = c + 1 }
    c is: 1

    arr for_every: 1 do: @{ is: 1 }
    arr for_every: 2 do: @{ is: 2 }
    arr for_every: 3 do: @{ is: 3 }
  }

  it: "returns the last index of an element or nil" with: 'last_index_of: when: {
    [] last_index_of: nil . is: nil
    [] last_index_of: 1 . is: nil
    [1,2,1,2] last_index_of: 1 . is: 2
    [1,2,1,2] last_index_of: 2 . is: 3
    [1,2,1,2] last_index_of: 3 . is: nil
  }

  it: "is selected from it with each index" with: 'select_with_index: when: {
    ["yooo",2,3,1,'foo,"bar"] select_with_index: |x i| { x is_a?: Fixnum } . is: [[2,1], [3,2], [1,3]]
  }

  it: "returns a chunked array based on a given block" with: 'chunk_by: when: {
    [] chunk_by: @{ nil? } . is: []
    [1] chunk_by: @{ nil? } . is: [[false, [1]]]
    [1,2] chunk_by: @{ odd? } . is: [
      [true, [1]],
      [false, [2]]
    ]

    [1,3,4,5,7,2,6,8,10,9] do: @{
      chunk_by: 'even? . is: [
        [false, [1,3]],
        [true, [4]],
        [false, [5,7]],
        [true, [2,6,8,10]],
        [false, [9]]
      ]

      chunk_by: 'odd? . is: [
        [true, [1,3]],
        [false, [4]],
        [true, [5,7]],
        [false, [2,6,8,10]],
        [true, [9]]
      ]

      chunk_by: 'nil? . is: [
        [false, [1,3,4,5,7,2,6,8,10,9]]
      ]
    }
  }

  it: "returns a hash grouped by the value returned by a block called with the elements" with: 'group_by: when: {
    [] group_by: 'nil? . is: <[]>
    [1,3,5] group_by: @{ odd? } . is: <[true => [1,3,5]]>
    (0,1,2,3) group_by: 'even? . is: <[false => [1,3], true => [0,2]]>
    ('foo, 1, 2, 'bar) group_by: @{ class } . is: <[Symbol => ['foo, 'bar], Fixnum => [1,2]]>
    "FooBar" group_by: @{ uppercase? } . is: <[true => ["F", "B"], false => ["o", "o", "a", "r"]]>
  }
}