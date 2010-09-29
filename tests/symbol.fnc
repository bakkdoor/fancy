FancySpec describe: Symbol with: {
  it: "should be usable like a block for Enumerable methods" when: {
    [1,2,3,4,5] map: 'squared .
      should == [1,4,9,16,25]

    ["hello", "world"] map: 'upcase .
      should == ["HELLO", "WORLD"]

    [1,2,3,4,5] select: 'even? .
      should == [2,4]
  }

  it: "should evaluate itself within the current scope" when: {
    x = 10
    'x eval should == x
  }
}
