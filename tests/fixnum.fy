FancySpec describe: Fixnum with: {
  it: "adds two numbers correctly" for: '+ when: {
    n1 = 20
    n2 = 22
    n1 + n2 is == 42
  }

  it: "subtracts two numbers correctly" for: '- when: {
    n1 = 20
    n2 = 22
    n1 - n2 is == -2
  }

  it: "multiplies two numbers correctly" for: '* when: {
    n1 = 20
    n2 = 22
    n1 * n2 is == 440
  }

  it: "divides two numbers correctly" for: '/ when: {
    n1 = 20
    n2 = 10
    n1 / n2 is == 2
  }

  it: "raises an exception when dividing by zero" when: {
    { 10 / 0 } is raise: ZeroDivisionError
  }

  it: "calculates the correct modulo value" for: 'modulo: when: {
    9 % 4 is == 1
    10 modulo: 2 . is == 0
  }

  it: "does proper integer division" for: 'div: when: {
    50 div: 10 . is == 5
    55 div: 10 . is == 5
    5 div: 10 . is == 0
    ((55 div: 10) * 10) + (55 modulo: 10) is == 55
  }

  it: "is the negation" for: 'negate when: {
    42 negate is == -42
  }

  it: "is odd" for: 'odd? when: {
    1 odd? is == true
    1 even? is == false
  }

  it: "is even" for: 'even? when: {
    2 odd? is == false
    2 even? is == true
  }

  it: "returns an array from 0 upto 10" for: 'upto: when: {
    0 upto: 10 . is == [0,1,2,3,4,5,6,7,8,9,10]
  }

  it: "iterates from 1 upto 10" for: 'upto:do: when: {
    sum = 0
    1 upto: 10 do: |n| { sum = sum + n }
    sum is == 55
  }

  it: "returns an array from 10 downto 0" for: 'downto: when: {
    10 downto: 0 . is == [10,9,8,7,6,5,4,3,2,1,0]
  }

  it: "iterates from 10 downto 1" for: 'downto:do: when: {
    sum = 0
    10 downto: 1 do: |n| { sum = sum + n }
    sum is == 55
  }

  it: "calculates the given power of itself" for: '** when: {
    2 ** 3 is == 8
    2 ** 0 is == 1
    2 ** 1 is == 2
    0 upto: 10 do: |i| {
      i ** 0 is == 1
      i ** 1 is == i
      i ** 2 is == (i squared)
    }
  }

  it: "is the square of self" for: 'squared when: {
    5 squared is == 25
    10 squared is == 100
    20 upto: 50 do: |i| {
      i squared is == (i * i)
    }
  }

  it: "is the double value of self" for: 'doubled when: {
    5 doubled is == 10
    10 doubled is == 20
    20 upto: 50 do: |i| {
      i doubled is == (i + i)
    }
  }

  it: "is the same when using underscores within the literal" when: {
    50000 is == 50_000
    100_000 is == 100000
    100_000 is == 100_000
    100_000 is == 100000.0
    100_000.0 is == 100000
    100_999.999 is == 100999.999
  }

  it: "evaluates octal literals correctly" when: {
    0o00 is == 0
    0o01 is == 1
    0o07 is == 7
    0o10 is == 8
    0o70 is == 56
  }

  it: "evaluates binary literals correctly" when: {
    0b00 is == 0
    0b01 is == 1
    0b10 is == 2
    0b11 is == 3
    0b100 is == 4
  }

  it: "evaluates hexadecimal literals correctly" when: {
    0x00 is == 0
    0x01 is == 1
    0x0A is == 10
    0xA0 is == 160
    0xFF is == 255
  }

  it: "calls a block a given amount of times" for: 'times: when: {
    times_called = 0
    10 times: { times_called = times_called + 1 }
    times_called is == 10

    sum = 0
    10 times: |i| { sum = sum + i }
    sum is == ((0..9) sum)
  }

  it: "calls a block a given amount of times with an offset" for: 'times:offset: when: {
    times_called = 0
    sum = 0
    10 times: |i| {
      times_called = times_called + 1
      sum = sum + i
    } offset: 10
    times_called is == 10
    sum is == ((10..19) sum)
  }
}
