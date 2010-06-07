FancySpec describe: Number with: |it| {
  it should: "add two numbers correctly" when: {
    n1 = 20;
    n2 = 22;
    n1 + n2 should_equal: 42
  };

  it should: "subtract two numbers correctly" when: {
    n1 = 20;
    n2 = 22;
    n1 - n2 should_equal: -2
  };

  it should: "multiply two numbers correctly" when: {
    n1 = 20;
    n2 = 22;
    n1 * n2 should_equal: 440
  };

  it should: "divide two numbers correctly" when: {
    n1 = 20;
    n2 = 10;
    n1 / n2 should_equal: 2
  };

  it should: "raise an exception when dividing by zero" when: {
    try {
      10 / 0;
      "This should not happen!" should_equal: nil
    } catch DivisionByZeroError => err {
      err message should_equal: "Division by zero!"
    }
  };

  it should: "calculate the correct modulo value" when: {
    9 % 4 should_equal: 1;
    10 modulo: 2 . should_equal: 0
  };

  it should: "be the negation" when: {
    42 negate should_equal: -42
  };

  it should: "be odd" when: {
    1 odd? should_equal: true;
    1 even? should_equal: false
  };

  it should: "be even" when: {
    2 odd? should_equal: false;
    2 even? should_equal: true
  };

  it should: "return an array from 0 upto 10" when: {
    0 upto: 10 . should_equal: [0,1,2,3,4,5,6,7,8,9,10]
  };

  it should: "return an array from 10 downto 0" when: {
    10 downto: 0 . should_equal: [10,9,8,7,6,5,4,3,2,1,0]
  };

  it should: "calculate the given power of itself" when: {
    2 ** 3 should_equal: 8;
    2 ** 0 should_equal: 1;
    2 ** 1 should_equal: 2;
    0 upto: 10 do_each: |i| {
      i ** 0 should_equal: 1;
      i ** 1 should_equal: i;
      i ** 2 should_equal: (i squared)
    }
  };

  it should: "be the square of self" when: {
    5 squared should_equal: 25;
    10 squared should_equal: 100;
    20 upto: 50 do_each: |i| {
      i squared should_equal: (i * i)
    }
  };

  it should: "be the double value of self" when: {
    5 doubled should_equal: 10;
    10 doubled should_equal: 20;
    20 upto: 50 do_each: |i| {
      i doubled should_equal: (i + i)
    }
  }
}
