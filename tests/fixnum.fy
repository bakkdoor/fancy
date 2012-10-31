FancySpec describe: Fixnum with: {
  it: "adds two numbers correctly" with: '+ when: {
    n1 = 20
    n2 = 22
    n1 + n2 is: 42
  }

  it: "subtracts two numbers correctly" with: '- when: {
    n1 = 20
    n2 = 22
    n1 - n2 is: -2
  }

  it: "multiplies two numbers correctly" with: '* when: {
    n1 = 20
    n2 = 22
    n1 * n2 is: 440
  }

  it: "divides two numbers correctly" with: '/ when: {
    n1 = 20
    n2 = 10
    n1 / n2 is: 2
  }

  it: "raises an exception when dividing by zero" when: {
    { 10 / 0 } is raise: ZeroDivisionError
  }

  it: "calculates the correct modulo value" with: 'modulo: when: {
    9 % 4 is: 1
    10 modulo: 2 . is: 0
  }

  it: "does proper integer division" with: 'div: when: {
    50 div: 10 . is: 5
    55 div: 10 . is: 5
    5 div: 10 . is: 0
    ((55 div: 10) * 10) + (55 modulo: 10) is: 55
  }

  it: "is the negation" with: 'negate when: {
    42 negate is: -42
  }

  it: "is odd" with: 'odd? when: {
    1 odd? is: true
    1 even? is: false
  }

  it: "is even" with: 'even? when: {
    2 odd? is: false
    2 even? is: true
  }

  it: "calculates the given power of itself" with: '** when: {
    2 ** 3 is: 8
    2 ** 0 is: 1
    2 ** 1 is: 2
    0 upto: 10 do: |i| {
      i ** 0 is: 1
      i ** 1 is: i
      i ** 2 is: (i squared)
    }
  }

  it: "is the same when using underscores within the literal" when: {
    50000 is: 50_000
    100_000 is: 100000
    100_000 is: 100_000
    100_000 is: 100000.0
    100_000.0 is: 100000
    100_999.999 is: 100999.999
  }

  it: "evaluates octal literals correctly" when: {
    0o00 is: 0
    0o01 is: 1
    0o07 is: 7
    0o10 is: 8
    0o70 is: 56
  }

  it: "evaluates binary literals correctly" when: {
    0b00 is: 0
    0b01 is: 1
    0b10 is: 2
    0b11 is: 3
    0b100 is: 4
  }

  it: "evaluates hexadecimal literals correctly" when: {
    0x00 is: 0
    0x01 is: 1
    0x0A is: 10
    0xA0 is: 160
    0xFF is: 255
  }

  it: "calls a block a given amount of times" with: 'times: when: {
    times_called = 0
    10 times: { times_called = times_called + 1 }
    times_called is: 10

    sum = 0
    10 times: |i| { sum = sum + i }
    sum is: ((0..9) sum)
  }

  it: "calls a block a given amount of times with an offset" with: 'times:offset: when: {
    times_called = 0
    sum = 0
    10 times: |i| {
      times_called = times_called + 1
      sum = sum + i
    } offset: 10
    times_called is: 10
    sum is: ((10..19) sum)
  }

  it: "tries to run a code block self amount of times or fails" with: 'times_try: when: {
    { -2 times_try: { 2 / 0 } } does_not raise: Exception
    { -1 times_try: { 2 / 0 } } does_not raise: Exception
    { 0 times_try: { 2 / 0 } } does_not raise: Exception
    { 1 times_try: { 2 / 0 } } raises: ZeroDivisionError
    { 2 times_try: { 2 / 0 } } raises: ZeroDivisionError

    tries = 0
    {
      2 times_try: {
        tries = tries + 1
        2 / 0
      }
    } raises: ZeroDivisionError
    tries is: 2

    2 times_try: { 2 } . is: 2

    i = 0
    2 times_try: { 2 / i } retry_with: { i = 1 } . is: 2
  }
}
