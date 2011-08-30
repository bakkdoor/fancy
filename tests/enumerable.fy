FancySpec describe: FancyEnumerable with: {
  it: "has ARGV correctly defined" with: 'superior_by:taking: when: {
    [1,2,3,4,5] superior_by: '> . is: 5
    [1,2,3,4,5] superior_by: '< . is: 1
    [[1,2], [2,3,4], [], [1]] superior_by: '> taking: 'size . is: [2,3,4]
    [[1,2], [2,3,4], [-1]] superior_by: '< taking: 'first . is: [-1]
  }
}