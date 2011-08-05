FancySpec describe: Symbol with: {
  it: "is usable like a block for Enumerable methods" with: 'call: when: {
    [1,2,3,4,5] map: 'squared .
      is: [1,4,9,16,25]

    ["hello", "world"] map: 'upcase .
      is: ["HELLO", "WORLD"]

    [1,2,3,4,5] select: 'even? .
      is: [2,4]
  }

  it: "evaluates itself within the current scope" with: 'eval when: {
    x = 10
    'x eval is: x
  }

  it: "sends itself to the sender in its context" with: 'call when: {
    def foo {
      "foo"
    }
    def bar {
      "bar"
    }
    x = false
    if: x then: 'foo else: 'bar . is: "bar"
    x = true
    if: x then: 'foo else: 'bar . is: "foo"
  }
}
