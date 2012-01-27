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
}