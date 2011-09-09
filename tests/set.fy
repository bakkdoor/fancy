FancySpec describe: Set with: {
  it: "creates a new Set with a given list of values" with: 'initialize: when: {
    s = Set new: [1,2,3]
    s size is: 3
    s values is: [1,2,3]
  }

  it: "creates a new empty Set" with: 'initialize when: {
    s = Set new
    s size is: 0
    s values is: []
  }

  it: "returns the values as an Array" with: 'values when: {
    s = Set new
    s << "foo"
    s << "bar"
    s << "foo"
    s values is: ["foo", "bar"]
  }

  it: "only keeps unique values" with: '[] when: {
    s = Set new
    s << 'foo
    s << 'foo
    s size is: 1
    s is: (Set[['foo]])
    s is_not: ['foo] # Sets and Arrays differ
  }

  it: "is empty" with: 'empty? when: {
    s = Set new
    s empty? is: true
    s = Set[[]]
    s empty? is: true
  }

  it: "is not empty" with: 'empty? when: {
    s = Set new
    s << 1
    s empty? is: false
    s = Set[[1,2,3]]
    s empty? is: false
  }

  it: "has the correct size" with: 'size when: {
    s = Set new
    s size is: 0
    s << 'foo
    s size is: 1
    10 times: {
      s << 'bar # only inserted once
    }
    s size is: 2
  }

  it: "is equal to another set" with: '== when: {
    s1 = Set new
    s2 = Set new
    s1 == s2 is: true

    s1 = Set[[1,2,3]]
    s2 = Set[[3,2,1]]
    s3 = Set[[3,1,2]]
    s1 == s2 is: true
    s1 == s3 is: true
    s2 == s1 is: true
    s2 == s3 is: true
    s3 == s1 is: true
    s3 == s2 is: true

    s1 << 1 # should have no effect
    s2 << 3
    s2 == s1 is: true
  }

  it: "includes a value" with: 'includes?: when: {
    s = Set[[1,2,3,"foo", 'bar, 10.0, 10.1]]
    s includes?: 1 . is: true
    s includes?: 2 . is: true
    s includes?: 3 . is: true
    s includes?: "foo" . is: true
    s includes?: 'bar . is: true
    s includes?: 10.0 . is: true
    s includes?: 10.1 . is: true
    s includes?: 'hello . is: false
    s includes?: nil . is: false
  }

  it: "calls a Block with each value" with: 'each: when: {
    s = Set[[1,2,3,4]]
    sum = 0
    s each: |val| {
      sum = sum + val
      s includes?: val . is: true
    }
   sum is: (s sum)
  }

  it: "removes a value in the Set" with: 'remove: when: {
    s = Set[(1,2,3)]
    s remove: 2
    s is: (Set[(1,3)])
    s remove: 1
    s is: (Set[[3]])
    s remove: 3
    s empty? . is: true
  }

  it: "returns the union of two sets" with: '+ when: {
    s1 = Set[(1,2,3)]
    s2 = Set[(3,4,5)]
    s1 + s2 is: (Set[(1,2,3,4,5)])
  }

  it: "returns the difference of two sets" with: '- when: {
    s1 = Set[(1,2,3)]
    s2 = Set[(3,4,5)]
    s1 - s2 is: (Set[(1,2)])
  }

  it: "returns the intersection of two sets" with: '& when: {
    s1 = Set[(1,2,3)]
    s2 = Set[(2,3,4,5)]
    s1 & s2 is: (Set[(2,3)])
  }
}
