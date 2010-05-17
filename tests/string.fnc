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
  };

  it should: "iterate over each character in a string" when: {
    str = "Hello, World!";
    i = 0;
    str each: |char| {
      char should_equal: $ str[i];
      i = i + 1
    }
  };

  it should: "behave like a collection/sequence via each:" when: {
    str = "Hello, World!";
    str uniq join: "" . should_equal: "Helo, Wrd!"
  };

  it should: "have all its characters as instances of String class" when: {
    str = "foo bar baz";
    str all?: |c| { c is_a?: String } . should_equal: true
  };

  it should: "drop all characters upto a whitespace" when: {
    "hello world" drop_while: |c| { c != " " } . join: "" . should_equal: "world"
  };

  it should: "be empty" when: {
    "" empty? should_equal: true;
    " " empty? should_equal: nil;
    String new empty? should_equal: true
  };

  it should: "be blank" when: {
    "" blank? should_equal: true;
    " " blank? should_equal: true;
    "-" blank? should_equal: nil;
    "       " blank? should_equal: true;
    "hello world" blank? should_equal: nil;
    "hello world" at: 5 . blank? should_equal: true
  }
}
