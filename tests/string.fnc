FancySpec describe: String with: |it| {
  it should: "be the empty string on initialization" when: {
    str = String new;
    str should == ""
  };

  it should: "be the concatination of the strings" when: {
    str1 = "hello ";
    str2 = "world";
    str3 = "!";
    str1 + str2 + str3 should == "hello world!"
  };

  it should: "concatenate the argument's string value with a string" when: {
    "I'm " ++ 21 ++ " years old!" should == "I'm 21 years old!"
  };

  it should: "return the correct substring" when: {
    "hello, world" from: 2 to: 5 . should == "llo,";
    "hello, world"[[2,5]] . should == "llo,"
  };

  it should: "return the upcased string" when: {
    "hello, world" upcase should == "HELLO, WORLD"
  };

  it should: "return the downcased string" when: {
    "HELLO, WORLD" downcase should == "hello, world"
  };

  it should: "return the same string by down- and upcasing in a row" when: {
    "HELLO, WORLD" downcase upcase should == "HELLO, WORLD"
  };

  it should: "iterate over each character in a string" when: {
    str = "Hello, World!";
    i = 0;
    str each: |char| {
      char should == (str[i]);
      i = i + 1
    }
  };

  it should: "behave like a collection/sequence via each:" when: {
    str = "Hello, World!";
    str uniq join: "" . should == "Helo, Wrd!"
  };

  it should: "have all its characters as instances of String class" when: {
    str = "foo bar baz";
    str all?: |c| { c is_a?: String } . should == true
  };

  it should: "drop all characters upto a whitespace" when: {
    "hello world" drop_while: |c| { c != " " } . join: "" . should == "world"
  };

  it should: "be empty" when: {
    "" empty? should == true;
    " " empty? should == nil;
    String new empty? should == true
  };

  it should: "be blank" when: {
    "" blank? should == true;
    " " blank? should == true;
    "-" blank? should == nil;
    "       " blank? should == true;
    "hello world" blank? should == nil;
    "hello world" at: 5 . blank? should == true
  };

  it should: "be evaled as fancy code and return the correct value" when: {
    x = ":foo" eval;
    x should == :foo;
    "3 + 4" eval should == 7;
    ":foo to_s upcase" eval should == "FOO";
    "33.33" eval should == 33.33
  };

  it should: "return itself times n" when: {
    "foo" * 2 should == "foofoo";
    "f" ++ ("o" * 2) ++ "bar" should == "foobar"
  };

  it should: "split a string at a given seperator string" when: {
    str = "hello, world, how are you?";
    str split: ", " . should == ["hello", "world", "how are you?"];
    "1,2,3,,4,5" split: "," . should == ["1", "2", "3", "", "4", "5"]
  }
}
