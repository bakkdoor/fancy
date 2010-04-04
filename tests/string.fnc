FancySpec describe: String with: |it| {
  it should: "be the empty string on initialization" when: {
    str = String new;
    str should_equal: ""
  };
  
  it should: "be the concatination of the strings" when: {
    str1 = "hello ";
    str2 = "world";
    str3 = "!";
    str1 + str2 + str3 should_equal: "hello world!"
  };

  it should: "concatenate the argument's string value with a string" when: {
    "I'm " ++ 21 ++ " years old!" should_equal: "I'm 21 years old!"
  };

  it should: "return the correct substring" when: {
    "hello, world" from: 2 to: 5 . should_equal: "llo,"
  };

  it should: "return the upcased string" when: {
    "hello, world" upcase should_equal: "HELLO, WORLD"
  };

  it should: "return the downcased string" when: {
    "HELLO, WORLD" downcase should_equal: "hello, world"
  };

  it should: "return the same string by down- and upcasing in a row" when: {
    "HELLO, WORLD" downcase upcase should_equal: "HELLO, WORLD"
  }
}
