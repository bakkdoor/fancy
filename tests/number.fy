FancySpec describe: Number with: {
  it: "returns an array from 0 upto 10" with: 'upto: when: {
    0 upto: 10 . is: [0,1,2,3,4,5,6,7,8,9,10]
  }

  it: "iterates from 1 upto 10" with: 'upto:do: when: {
    sum = 0
    1 upto: 10 do: |n| { sum = sum + n }
    sum is: 55
  }

  it: "iterates from 1 upto 20 in steps of 4" when: {
    sum = 0
    1 upto: 20 in_steps_of: 4 do: |n| {
      sum = sum + n
    }
    sum is: $ [1,5,9,13,17] sum
  }

  it: "returns an array from 10 downto 0" with: 'downto: when: {
    10 downto: 0 . is: [10,9,8,7,6,5,4,3,2,1,0]
  }

  it: "iterates from 10 downto 1" with: 'downto:do: when: {
    sum = 0
    10 downto: 1 do: |n| { sum = sum + n }
    sum is: 55
  }

  it: "iterates from 20 downto 1 in steps of 4" when: {
    sum = 0
    20 downto: 1 in_steps_of: 4 do: |n| {
      sum = sum + n
    }
    sum is: $ [0,4,8,12,16,20] sum
  }

  it: "is the square of self" with: 'squared when: {
    5 squared is: 25
    10 squared is: 100
    20 upto: 50 do: |i| {
      i squared is: (i * i)
    }
  }

  it: "returns the cubed value of self" with: 'cubed when: {
    5 cubed is: 125
    10 cubed is: 1000
    20 upto: 50 do: |i| {
      i cubed is: (i * i * i)
    }
  }

  it: "is the double value of self" with: 'doubled when: {
    5 doubled is: 10
    10 doubled is: 20
    20 upto: 50 do: |i| {
      i doubled is: (i + i)
    }
  }

  it: "returns the maximum" with: 'max: when: {
    0 max: 0 . is: 0
    1 max: 2 . is: 2
    2 max: 1 . is: 2
    -2 max: -3 . is: -2
  }

  it: "returns the minimum" with: 'min: when: {
    0 min: 0 . is: 0
    -1 min: 0 . is: -1
    -2 min: -3 . is: -3
    2 min: 1 . is: 1
  }
}