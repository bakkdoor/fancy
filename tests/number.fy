FancySpec describe: Number with: {
  it: "should add two numbers correctly" for: '+ when: {
    n1 = 20
    n2 = 22
    n1 + n2 should == 42
  }

  it: "should subtract two numbers correctly" for: '- when: {
    n1 = 20
    n2 = 22
    n1 - n2 should == -2
  }

  it: "should multiply two numbers correctly" for: '* when: {
    n1 = 20
    n2 = 22
    n1 * n2 should == 440
  }

  it: "should divide two numbers correctly" for: '/ when: {
    n1 = 20
    n2 = 10
    n1 / n2 should == 2
  }

  it: "should raise an exception when dividing by zero" when: {
    { 10 / 0 } should raise: ZeroDivisionError
  }

  it: "should calculate the correct modulo value" for: 'modulo: when: {
    9 % 4 should == 1
    10 modulo: 2 . should == 0
  }

  it: "should do proper integer division" for: 'div: when: {
    50 div: 10 . should == 5
    55 div: 10 . should == 5
    5 div: 10 . should == 0
    ((55 div: 10) * 10) + (55 modulo: 10) should == 55
  }

  it: "should be the negation" for: 'negate when: {
    42 negate should == -42
  }

  it: "should be odd" for: 'odd? when: {
    1 odd? should == true
    1 even? should == false
  }

  it: "should be even" for: 'even? when: {
    2 odd? should == false
    2 even? should == true
  }

  it: "should return an array from 0 upto 10" for: 'upto: when: {
    0 upto: 10 . should == [0,1,2,3,4,5,6,7,8,9,10]
  }

  it: "should iterate from 1 upto 10" for: 'upto:do: when: {
    sum = 0
    1 upto: 10 do: |n| { sum = sum + n }
    sum should == 55
  }

  it: "should return an array from 10 downto 0" for: 'downto: when: {
    10 downto: 0 . should == [10,9,8,7,6,5,4,3,2,1,0]
  }

  it: "should iterate from 10 downto 1" for: 'downto:do: when: {
    sum = 0
    10 downto: 1 do: |n| { sum = sum + n }
    sum should == 55
  }

  it: "should calculate the given power of itself" for: '** when: {
    2 ** 3 should == 8
    2 ** 0 should == 1
    2 ** 1 should == 2
    0 upto: 10 do: |i| {
      i ** 0 should == 1
      i ** 1 should == i
      i ** 2 should == (i squared)
    }
  }

  it: "should be the square of self" for: 'squared when: {
    5 squared should == 25
    10 squared should == 100
    20 upto: 50 do: |i| {
      i squared should == (i * i)
    }
  }

  it: "should be the double value of self" for: 'doubled when: {
    5 doubled should == 10
    10 doubled should == 20
    20 upto: 50 do: |i| {
      i doubled should == (i + i)
    }
  }

  it: "should be the same when using underscores within the literal" when: {
    50000 should == 50_000
    100_000 should == 100000
    100_000 should == 100_000
    100_000 should == 100000.0
    100_000.0 should == 100000
    100_999.999 should == 100999.999
  }

  it: "should evaluate octal literals correctly" when: {
    0o00 should == 0
    0o01 should == 1
    0o07 should == 7
    0o10 should == 8
    0o70 should == 56
  }

  it: "should evaluate binary literals correctly" when: {
    0b00 should == 0
    0b01 should == 1
    0b10 should == 2
    0b11 should == 3
    0b100 should == 4
  }

  it: "should evaluate hexadecimal literals correctly" when: {
    0x00 should == 0
    0x01 should == 1
    0x0A should == 10
    0xA0 should == 160
    0xFF should == 255
  }
}
