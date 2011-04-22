FancySpec describe: String with: {
  it: "should be the empty string on initialization" when: {
    str = String new
    str should == ""
  }

  it: "should be the concatination of the strings" for: '+ when: {
    str1 = "hello "
    str2 = "world"
    str3 = "!"
    str1 + str2 + str3 should == "hello world!"
  }

  it: "should concatenate the argument's string value with a string" for: '++ when: {
    "I'm " ++ 21 ++ " years old!" should == "I'm 21 years old!"
  }

  it: "should return the correct substring" for: 'from:to: when: {
    "hello, world" from: 2 to: 5 . should == "llo,"
    "hello, world"[[2,5]] . should == "llo,"
  }

  it: "should return the upcased string" for: 'upcase when: {
    "hello, world" upcase should == "HELLO, WORLD"
  }

  it: "should return the downcased string" for: 'downcase when: {
    "HELLO, WORLD" downcase should == "hello, world"
  }

  it: "should return the same string by down- and upcasing in a row" when: {
    "HELLO, WORLD" downcase upcase should == "HELLO, WORLD"
  }

  it: "should iterate over each character in a string" for: 'each: when: {
    str = "Hello, World!"
    i = 0
    str each: |char| {
      char should == (str at: i)
      i = i + 1
    }
  }

  it: "should behave like a collection/sequence via each:" for: 'uniq when: {
    str = "Hello, World!"
    str uniq join: "" . should == "Helo, Wrd!"
  }

  it: "should have all its characters as instances of String class" for: 'all?: when: {
    str = "foo bar baz"
    str all?: |c| { c is_a?: String } . should == true
  }

  # it: "should drop all characters upto a whitespace" for: 'drop_while: when: {
  #   "hello world" drop_while: |c| { c != " " } . join: "" . should == " world"
  # }

  it: "should be empty" for: 'empty? when: {
    "" empty? should == true
    " " empty? should == false
    String new empty? should == true
  }

  # it: "should be blank" for: 'blank? when: {
  #   "" blank? should == true
  #   " " blank? should == true
  #   "-" blank? should == false
  #   "       " blank? should == true
  #   "hello world" blank? should == false
  #   "hello world" at: 5 . blank? should == true
  # }

  # it: "should be evaled as fancy code and return the correct value" when: {
  #   x = "'foo" eval
  #   x should == 'foo
  #   "3 + 4" eval should == 7
  #   "'foo to_s upcase" eval should == "FOO"
  #   "33.33" eval should == 33.33
  # }

  it: "should return itself times n" for: '* when: {
    "foo" * 2 should == "foofoo"
    "f" ++ ("o" * 2) ++ "bar" should == "foobar"
  }

  it: "should split a string at a given seperator string" for: 'split: when: {
    str = "hello, world, how are you?"
    str split: ", " . should == ["hello", "world", "how are you?"]
    "1,2,3,,4,5" split: "," . should == ["1", "2", "3", "", "4", "5"]
    ",1,2,3,4," split: "," . should == ["", "1", "2", "3", "4"]
    "foo bar\n baz yo" split should == ["foo", "bar", "baz", "yo"]
    "foo bar\n baz yo" words should == ["foo", "bar", "baz", "yo"]
  }

  it: "should support basic string interpolation" when: {
    "hello, #{10 * 10} world!" should == "hello, 100 world!"
    x = "world"
    "hello, #{x}!!" should == "hello, world!!"

    "hello, #{x}, Fancy #{'rocks to_s upcase}!!" should == "hello, world, Fancy ROCKS!!"
  }

  it: "should return the String as a Symbol" for: 'to_sym when: {
    "foo" to_sym should == 'foo
    "foo:bar:" to_sym should == 'foo:bar:
    "FooBar?!" to_sym should == 'FooBar?!
    "+-&/^\?a!" to_sym should '+-&/^\?a!
  }
}
