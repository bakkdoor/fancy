FancySpec describe: String with: {
  it: "is the empty string on initialization" when: {
    str = String new
    str is == ""
  }

  it: "is the concatination of the strings" for: '+ when: {
    str1 = "hello "
    str2 = "world"
    str3 = "!"
    str1 + str2 + str3 is == "hello world!"
  }

  it: "concatenates the argument's string value with a string" for: '++ when: {
    "I'm " ++ 21 ++ " years old!" is == "I'm 21 years old!"
  }

  it: "returns the correct substring" for: 'from:to: when: {
    "hello, world" from: 2 to: 5 . is == "llo,"
    "hello, world"[[2,5]] . is == "llo,"
  }

  it: "returns the upcased string" for: 'upcase when: {
    "hello, world" upcase is == "HELLO, WORLD"
  }

  it: "returns the downcased string" for: 'downcase when: {
    "HELLO, WORLD" downcase is == "hello, world"
  }

  it: "returns the same string by down- and upcasing in a row" when: {
    "HELLO, WORLD" downcase upcase is == "HELLO, WORLD"
  }

  it: "iterates over each character in a string" for: 'each: when: {
    str = "Hello, World!"
    i = 0
    str each: |char| {
      char is == (str at: i)
      i = i + 1
    }
  }

  it: "behaves like a collection/sequence via each:" for: 'uniq when: {
    str = "Hello, World!"
    str uniq join: "" . is == "Helo, Wrd!"
  }

  it: "has all its characters as instances of String class" for: 'all?: when: {
    str = "foo bar baz"
    str all?: |c| { c is_a?: String } . is == true
  }

  it: "drops all characters upto a whitespace" for: 'drop_while: when: {
    "hello world" drop_while: |c| { c != " " } . join: "" . is == " world"
  }

  it: "is empty" for: 'empty? when: {
    "" empty? is == true
    " " empty? is == false
    String new empty? is == true
  }

  it: "is blank" for: 'blank? when: {
    "" blank? is == true
    " " blank? is == true
    "-" blank? is == false
    "       " blank? is == true
    "hello world" blank? is == false
    "hello world" at: 5 . blank? is == true
  }

  it: "is evaluated as fancy code and returns the correct value" when: {
    x = "'foo" eval
    x is == 'foo
    "3 + 4" eval is == 7
    "'foo to_s upcase" eval is == "FOO"
    "33.33" eval is == 33.33
  }

  it: "returns itself times n" for: '* when: {
    "foo" * 2 is == "foofoo"
    "f" ++ ("o" * 2) ++ "bar" is == "foobar"
  }

  it: "splits a string at a given seperator string" for: 'split: when: {
    str = "hello, world, how are you?"
    str split: ", " . is == ["hello", "world", "how are you?"]
    "1,2,3,,4,5" split: "," . is == ["1", "2", "3", "", "4", "5"]
    ",1,2,3,4," split: "," . is == ["", "1", "2", "3", "4"]
    "foo bar\n baz yo" split is == ["foo", "bar", "baz", "yo"]
    "foo bar\n baz yo" words is == ["foo", "bar", "baz", "yo"]
  }

  it: "supports basic string interpolation" when: {
    "hello, #{10 * 10} world!" is == "hello, 100 world!"
    x = "world"
    "hello, #{x}!!" is == "hello, world!!"

    "hello, #{x}, Fancy #{'rocks to_s upcase}!!" is == "hello, world, Fancy ROCKS!!"
  }

  it: "returns the String as a Symbol" for: 'to_sym when: {
    "foo" to_sym is == 'foo
    "foo:bar:" to_sym is == 'foo:bar:
    "FooBar?!" to_sym is == 'FooBar?!
    "+-&/^\?a!" to_sym is '+-&/^\?a!
  }

  it: "allows replacing characters in the string" for: '[]: when: {
    s = "hello"
    s[0]: "H"
    s is == "Hello"
    s[0]: "Good day. H"
    s is == "Good day. Hello"
    s[-1]: "o."
    s is == "Good day. Hello."
  }

  it: "contains a substring" for: 'includes?: when: {
    "foo bar baz" includes?: "foo" is == true
    "foo bar baz" includes?: "bar" is == true
    "foo bar baz" includes?: "baz" is == true
    "foo bar baz" includes?: " " is == true
    "foo bar baz" includes?: "" is == true
    "foo bar baz" includes?: "foobarbaz" is == false
  }

  it: "should remove any leading indentation" for: 'skip_leading_indentation when: {
    """
    hello, world!
    how are you?
    """ skip_leading_indentation is == "hello, world!\nhow are you?"

    str = """
    foo, bar
    """
    str skip_leading_indentation is_not == str
  }
}
