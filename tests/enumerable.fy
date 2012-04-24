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
      include: Fancy Enumerable
      def each: block {
        (0..5) each: block
      }
    }
    MyCollection new to_s is: "012345"
  }
}