FancySpec describe: Block with: |it| {
  it should: "return the value of the last expression" when: {
    block = {
      a = "a";
      empty = " ";
      str = "String!";
      a ++ empty ++ str
    };
    block call should_equal: "a String!"
  };

  it should: "close over a value and change it internally" when: {
    x = 0;
    { x < 10 } while_true: {
      x should_be: |x| { x < 10 };
      x = x + 1
    };
    x should_equal: 10
  };

  it should: "return its arguments as an array of strings" when: {
    { } arguments . should_equal: [];
    |x| { } arguments . should_equal: [:x];
    |x, y, z| { } arguments . should_equal: [:x, :y, :z]
  };

  it should: "return the argument count" when: {
    { } argcount . should_equal: 0;
    |x| { } argcount . should_equal: 1;
    |x,y,z| { } argcount . should_equal: 3
  }
}
