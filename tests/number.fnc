FancySpec describe: Number with: |it| {
  it should: "add two numbers correctly" for: '+ when: {
    n1 = 20;
    n2 = 22;
    n1 + n2 should == 42
  };

  it should: "subtract two numbers correctly" for: '- when: {
    n1 = 20;
    n2 = 22;
    n1 - n2 should == -2
  };

  it should: "multiply two numbers correctly" for: '* when: {
    n1 = 20;
    n2 = 22;
    n1 * n2 should == 440
  };

  it should: "divide two numbers correctly" for: '/ when: {
    n1 = 20;
    n2 = 10;
    n1 / n2 should == 2
  };

  it should: "raise an exception when dividing by zero" when: {
    try {
      10 / 0;
      "This should not happen!" should == nil
    } catch DivisionByZeroError => err {
      err message should == "Division by zero!"
    }
  };

  it should: "calculate the correct modulo value" for: 'modulo: when: {
    9 % 4 should == 1;
    10 modulo: 2 . should == 0
  };

  it should: "be the negation" for: 'negate when: {
    42 negate should == -42
  };

  it should: "be odd" for: 'odd? when: {
    1 odd? should == true;
    1 even? should == nil
  };

  it should: "be even" for: 'even? when: {
    2 odd? should == nil;
    2 even? should == true
  };

  it should: "return an array from 0 upto 10" for: 'upto: when: {
    0 upto: 10 . should == [0,1,2,3,4,5,6,7,8,9,10]
  };

  it should: "return an array from 10 downto 0" for: 'downto: when: {
    10 downto: 0 . should == [10,9,8,7,6,5,4,3,2,1,0]
  };

  it should: "calculate the given power of itself" for: '** when: {
    2 ** 3 should == 8;
    2 ** 0 should == 1;
    2 ** 1 should == 2;
    0 upto: 10 do_each: |i| {
      i ** 0 should == 1;
      i ** 1 should == i;
      i ** 2 should == (i squared)
    }
  };

  it should: "be the square of self" for: 'squared when: {
    5 squared should == 25;
    10 squared should == 100;
    20 upto: 50 do_each: |i| {
      i squared should == (i * i)
    }
  };

  it should: "be the double value of self" for: 'doubled when: {
    5 doubled should == 10;
    10 doubled should == 20;
    20 upto: 50 do_each: |i| {
      i doubled should == (i + i)
    }
  }
}
