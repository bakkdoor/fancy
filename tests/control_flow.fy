FancySpec describe: "Control Flow" with: {

  it: "should NOT call the block if not nil" for: 'if_nil: when: {
    'foo if_nil: { 'is_nil } . should == nil
    "hello, world" if_nil: { 'is_nil } . should == nil
  }

  it: "should work like if_true:" for: 'if:then: when: {
    if: (4 < 5) then: {
      4 < 5 should == true
    }
  }

  it: "should work like if_true:else: " for: 'if:then:else: when: {
    if: (4 < 5) then: {
      4 < 5 should == true
    } else: {
      4 < 5 should == nil
    }
  }

  it: "should work like while_true:" for: 'while:do: when: {
    x = 0
    while: { x < 10 } do: {
      x < 10 should == true
      x = x + 1
    }
    x == 10 should == true
  }

  it: "should work like while_false: " for: 'until:do: when: {
    x = 0
    until: { x == 10 } do: {
      x < 10 should == true
      x = x + 1
    }
    x == 10 should == true
  }

  it: "should work like if_false:: " for: 'unless:do: when: {
    unless: (4 > 5) do: {
      5 > 4 should == true
    }
  }

  it: "should only call the block if it's a true-ish value" for: 'if_do: when: {
    1 if_do: |num| {
      num * 10
    } . should == 10

    nil if_do: {
      "nope"
    } . should == nil

    false if_do: {
      "nope again"
    } . should == nil
  }

  it: "should call the then_block if it's a true-ish value and call the else_block otherwise" for: 'if_do:else: when: {
    1 if_do: |num| {
      num * 10
    } else: {
      nil
    } . should == 10

    nil if_do: {
      "nope"
    } else: {
      "yup"
    } . should == "yup"

    false if_do: {
      "nope again"
    } else: {
      "yup again"
    } . should == "yup again"
  }

  it: "should break from an iteration" for: 'break when: {
    x = 0
    until: { x == 10 } do: {
      x = x + 1
      { break } if: (x == 5)
    }
    x == 5 should == true
  }

  it: "should break from an iteration with return value" for: 'break: when: {
    x = 0
    y = until: { x == 10 } do: {
      x = x + 1
      { break: 42 } if: (x == 5)
    }

    x should == 5
    y should == 42
  }

  it: "should skip an iteration over a Range" for: 'next when: {
    total = 0
    (1..10) each: |i| {
      { next } if: (i == 5)
      total = total + i
    }
    total should == 50
  }

  it: "should skip an iteration over an Array" for: 'next when: {
    total = 0
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] each: |i| {
      { next } if: (i == 5)
      total = total + i
    }
    total should == 50
  }

  it: "should skip an iteration over an Hash" for: 'next when: {
    total = 0
    <['a => 1, 'b => 2, 'c => 3, 'd => 4, 'e => 5, 'f => 6]> each: |k v| {
      { next } if: (k == 'd)
      total = total + v
    }
    total should == 17
  }

  it: "stops any loop type at the correct spot" for: 'break when: {
    i = 0
    loop: {
      { break } if: (i == 3)
      i = i + 1
    }
    i should == 3

    i = 0
    while: { i < 5 } do: {
      { break } if: (i == 3)
      i = i + 1
    }
    i should == 3

    i = 0
    0 upto: 5 do: |n| {
      i = n
      { break } if: (n == 3)
    }
    i should == 3
  }

  it: "stops any loop type at the correct spot" for: 'break: when: {
    i = 0
    loop: {
      { break: i } if: (i == 2)
      i = i + 1
    } . should == 2

    i = 0
    while: { i < 5 } do: {
      { break: i } if: (i == 2)
      i = i + 1
    } . should == 2

    i = 0
    0 upto: 5 do: |n| {
      i = n
      { break: n } if: (n == 2)
    }
    i should == 2
  }

  it: "should allow empty try blocks" when: {
    x = "foo"
    try {
    } finally {
      x should == "foo"
    }
  }
}