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

  it: "returns self" with: 'to_sym when: {
    'foo to_sym is: 'foo
    'bar to_sym is: 'bar
  }

  it: "returns itself as a Block" with: 'to_block when: {
    b = 'inspect to_block
    b call: [2] . is: "2"
    b call: ["foo"] . is: "\"foo\""

    str = "hello, world yo!\"foo\""
    b call: [str] . is: $ @{ inspect } call: [str]
  }
}
