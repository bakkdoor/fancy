FancySpec describe: String with: {
  it: "is the empty string on initialization" when: {
    str = String new
    str is: ""
  }

  it: "is the concatination of the strings" with: '+ when: {
    str1 = "hello "
    str2 = "world"
    str3 = "!"
    str1 + str2 + str3 is: "hello world!"
  }

  it: "concatenates the argument's string value with a string" with: '++ when: {
    "I'm " ++ 21 ++ " years old!" is: "I'm 21 years old!"
  }

  it: "returns the correct substring" with: 'from:to: when: {
    "hello, world" from: 2 to: 5 . is: "llo,"
    "hello, world"[[2,5]] . is: "llo,"
  }

  it: "returns the upcased string" with: 'upcase when: {
    "hello, world" upcase is: "HELLO, WORLD"
  }

  it: "returns the downcased string" with: 'downcase when: {
    "HELLO, WORLD" downcase is: "hello, world"
  }

  it: "returns the same string by down- and upcasing in a row" when: {
    "HELLO, WORLD" downcase upcase is: "HELLO, WORLD"
  }

  it: "iterates over each character in a string" with: 'each: when: {
    str = "Hello, World!"
    i = 0
    str each: |char| {
      char is: (str at: i)
      i = i + 1
    }
  }

  it: "behaves like a collection/sequence via each:" with: 'uniq when: {
    str = "Hello, World!"
    str uniq join: "" . is: "Helo, Wrd!"
  }

  it: "has all its characters as instances of String class" with: 'all?: when: {
    str = "foo bar baz"
    str all?: |c| { c is_a?: String } . is: true
  }

  it: "drops all characters upto a whitespace" with: 'drop_while: when: {
    "hello world" drop_while: |c| { c != " " } . join: "" . is: " world"
  }

  it: "is empty" with: 'empty? when: {
    "" empty? is: true
    " " empty? is: false
    String new empty? is: true
  }

  it: "is blank" with: 'blank? when: {
    "" blank? is: true
    " " blank? is: true
    "-" blank? is: false
    "       " blank? is: true
    "hello world" blank? is: false
    "hello world" at: 5 . blank? is: true
  }

  it: "is evaluated as fancy code and returns the correct value" when: {
    x = "'foo" eval
    x is: 'foo
    "3 + 4" eval is: 7
    "'foo to_s upcase" eval is: "FOO"
    "33.33" eval is: 33.33
  }

  it: "returns itself times n" with: '* when: {
    "foo" * 2 is: "foofoo"
    "f" ++ ("o" * 2) ++ "bar" is: "foobar"
  }

  it: "splits a string at a given seperator string" with: 'split: when: {
    str = "hello, world, how are you?"
    str split: ", " . is: ["hello", "world", "how are you?"]
    "1,2,3,,4,5" split: "," . is: ["1", "2", "3", "", "4", "5"]
    ",1,2,3,4," split: "," . is: ["", "1", "2", "3", "4"]
    "foo bar\n baz yo" split is: ["foo", "bar", "baz", "yo"]
    "foo bar\n baz yo" words is: ["foo", "bar", "baz", "yo"]
  }

  it: "supports basic string interpolation" when: {
    "hello, #{10 * 10} world!" is: "hello, 100 world!"
    x = "world"
    "hello, #{x}!!" is: "hello, world!!"

    "hello, #{x}, Fancy #{'rocks to_s upcase}!!" is: "hello, world, Fancy ROCKS!!"
  }

  it: "supports string interpolation with multi-line strings" when: {
    str = """
    the next line contains 7:
#{3 + 4}
"""
    str lines size is: 3
    str lines last is: "7"
  }

  it: "returns the String as a Symbol" with: 'to_sym when: {
    "foo" to_sym is: 'foo
    "foo:bar:" to_sym is: 'foo:bar:
    "FooBar?!" to_sym is: 'FooBar?!
    "+-&/^\?a!" to_sym is '+-&/^\?a!
  }

  it: "allows replacing characters in the string" with: '[]: when: {
    s = "hello"
    s[0]: "H"
    s is: "Hello"
    s[0]: "Good day. H"
    s is: "Good day. Hello"
    s[-1]: "o."
    s is: "Good day. Hello."
  }

  it: "contains a substring" with: 'includes?: when: {
    "foo bar baz" includes?: "foo" . is: true
    "foo bar baz" includes?: "bar" . is: true
    "foo bar baz" includes?: "baz" . is: true
    "foo bar baz" includes?: " " . is: true
    "foo bar baz" includes?: "" . is: true
    "foo bar baz" includes?: "foobarbaz" . is: false
  }

  it: "removes any leading indentation" with: 'skip_leading_indentation when: {
    """
    hello, world!
    how are you?
    """ skip_leading_indentation is: "hello, world!\nhow are you?"

    str = """
    foo, bar
    """
    str skip_leading_indentation is_not: str
  }

  it: "returns an array of all its characters" with: 'characters when: {
    "foo" characters is: ["f","o","o"]
    "" characters is: []
    "f" characters is: ["f"]
  }

  it: "returns its first character as a fixnum ascii value" with: 'character when: {
    "A" character is: 65
    "a" character is: 97
    "ab" character is: $ "a" character
    "" character is: nil
  }

  it: "returns an enumerator for its all bytes (fixnum ascii values)" with: 'bytes when: {
    "foo" bytes class is: FancyEnumerator
    "" bytes class is: FancyEnumerator
  }

  it: "returns a joined string using FancyEnumerable#join:" for: 'join: when: {
    "foobar" join: "-" . is: "f-o-o-b-a-r"
    "" join: "-" . is: ""
  }
}
