FancySpec describe: "Control Flow" with: {

  it: "should NOT call the block if not nil" for: 'if_nil: when: {
    'foo if_nil: { 'is_nil } . is == nil
    "hello, world" if_nil: { 'is_nil } . is == nil
  }

  it: "should work like if_true:" for: 'if:then: when: {
    if: (4 < 5) then: {
      4 < 5 is == true
    }
  }

  it: "should work like if_true:else: " for: 'if:then:else: when: {
    if: (4 < 5) then: {
      4 < 5 is == true
    } else: {
      4 < 5 is == nil
    }
  }

  it: "should work like while_true:" for: 'while:do: when: {
    x = 0
    while: { x < 10 } do: {
      x < 10 is == true
      x = x + 1
    }
    x == 10 is == true
  }

  it: "should work like while_false: " for: 'until:do: when: {
    x = 0
    until: { x == 10 } do: {
      x < 10 is == true
      x = x + 1
    }
    x == 10 is == true
  }

  it: "should call a block while another one is true, but call it at least once" for: 'do:while: when: {
    x = 0
    arr = []
    do: {
      x < 10 is == true
      arr << x
      x = x + 1
    } while: { x < 10 }
    arr is == [0,1,2,3,4,5,6,7,8,9]

    times_called = 0
    do: {
      times_called = times_called + 1
    } while: { false }
    times_called is == 1
  }

  it: "should call a block until another one is true, but call it at least once" for: 'do:until: when: {
    x = 0
    do: {
      x < 10 is == true
      x = x + 1
    } until: { x == 10 }
    x is == 10

    times_called = 0
    do: {
      times_called = times_called + 1
    } until: { true }
    times_called is == 1
  }

  it: "should work like if_false:: " for: 'unless:do: when: {
    unless: (4 > 5) do: {
      5 > 4 is == true
    }
  }

  it: "should only call the block if it's a true-ish value" for: 'if_true: when: {
    1 if_true: |num| {
      num * 10
    } . is == 10

    nil if_true: {
      "nope"
    } . is == nil

    false if_true: {
      "nope again"
    } . is == nil
  }

  it: "should call the then_block if it's a true-ish value and call the else_block otherwise" for: 'if_true:else: when: {
    1 if_true: |num| {
      num * 10
    } else: {
      nil
    } . is == 10

    nil if_true: {
      "nope"
    } else: {
      "yup"
    } . is == "yup"

    false if_true: {
      "nope again"
    } else: {
      "yup again"
    } . is == "yup again"
  }

  it: "should be possible to override the if_true:else: method and work accordingly in conditionals" when: {
    class AClassThatIsLikeFalse {
      def if_true: block else: another_block {
        another_block call
      }
    }

    obj = AClassThatIsLikeFalse new
    if: obj then: {
      'fail
    } else: {
      'success
    } . is == 'success

    # let's get rid of this custom if_true:else: method
    AClassThatIsLikeFalse undefine_method: 'if_true:else:

    if: obj then: {
      'now_this_is_success
    } else: {
      'fail
    } . is == 'now_this_is_success
  }

  it: "should break from an iteration" for: 'break when: {
    x = 0
    until: { x == 10 } do: {
      x = x + 1
      { break } if: (x == 5)
    }
    x == 5 is == true
  }

  it: "should break from an iteration with return value" for: 'break: when: {
    x = 0
    y = until: { x == 10 } do: {
      x = x + 1
      { break: 42 } if: (x == 5)
    }

    x is == 5
    y is == 42
  }

  it: "should skip an iteration over a Range" for: 'next when: {
    total = 0
    (1..10) each: |i| {
      { next } if: (i == 5)
      total = total + i
    }
    total is == 50
  }

  it: "should skip an iteration over an Array" for: 'next when: {
    total = 0
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] each: |i| {
      { next } if: (i == 5)
      total = total + i
    }
    total is == 50
  }

  it: "should skip an iteration over an Hash" for: 'next when: {
    total = 0
    <['a => 1, 'b => 2, 'c => 3, 'd => 4, 'e => 5, 'f => 6]> each: |k v| {
      { next } if: (k == 'd)
      total = total + v
    }
    total is == 17
  }

  it: "stops any loop type at the correct spot" for: 'break when: {
    i = 0
    loop: {
      { break } if: (i == 3)
      i = i + 1
    }
    i is == 3

    i = 0
    while: { i < 5 } do: {
      { break } if: (i == 3)
      i = i + 1
    }
    i is == 3

    i = 0
    0 upto: 5 do: |n| {
      i = n
      { break } if: (n == 3)
    }
    i is == 3
  }

  it: "stops any loop type at the correct spot" for: 'break: when: {
    i = 0
    loop: {
      { break: i } if: (i == 2)
      i = i + 1
    } . is == 2

    i = 0
    while: { i < 5 } do: {
      { break: i } if: (i == 2)
      i = i + 1
    } . is == 2

    i = 0
    0 upto: 5 do: |n| {
      i = n
      { break: n } if: (n == 2)
    }
    i is == 2
  }

  it: "should allow empty try blocks" when: {
    x = "foo"
    try {
    } finally {
      x is == "foo"
    }
  }
}