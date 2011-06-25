FancySpec describe: "Pattern Matching" with: {
  it: "matches a value correctly by its class" when: {
    def do_match: obj {
      match obj {
        case String -> 'string
        case Fixnum -> 'fixnum
        case _ -> 'anything
      }
    }

    do_match: "foo" . is == 'string
    do_match: 42 . is == 'fixnum
    do_match: 'symbol . is == 'anything
    do_match: Object . is == 'anything
    do_match: 32.32 . is == 'anything
  }

  it: "binds a given match arg, if present, to the result of the match operation" when: {
    match "foobarbaz" {
      case /foo([a-z]+)baz/ -> |matcher|
        local1, local2, local3 = 'ignore, 'this_too, 'this_also
        matcher[1] is == "bar"
    }
  }

  it: "only binds a given match arg to the scope of the match case" when: {
    match "foobarbaz" {
      case /foo([a-z]+)baz/ -> |local_of_case|
        local_of_case == nil . is == false
    }

    local_of_case is == nil
  }

  it: "only binds locals of the match clause to the scope of the match case" when: {
    match "foobarbaz" {
      case /foo([a-z]+)baz/ -> |local_of_case|
        local1 = "Hi, I am some local, that is be gone after this block."
    }

    local1 is == nil
  }

  it: "binds any additional match args to the matched values" when: {
    str = "foo bar baz"
    match str {
      case /^foo (.*) (.*)$/ -> |all, match1, match2|
      all class is == MatchData
      match1 is == "bar"
      match2 is == "baz"
    }
  }

  it: "returns an instance of the apropriate MatchData class" when: {
    def create_tuple: num {
      (num, num * num) # create a Tuple
    }

    match create_tuple: 10 {
      case Tuple -> |md, x, y, z|
        # convention: md[0] always holds the entire object that was matched.
        md[0] is == (create_tuple: 10)
        x is == 10
        y is == 100
        z is == nil # tuple only has 2 entries
    }
  }

  it: "matches an array correctly" when: {
    def create_array: num {
      [num, num ** 2, num ** 3, num ** 4]
    }

    match create_array: 2 {
      case Array -> |_, a,b,c,d|
        a is == 2
        b is == (2 ** 2)
        c is == (2 ** 3)
        d is == (2 ** 4)
    }
  }

  it: "does not try to bind the match args if the match failed" when: {
    ["hello world!", "hello you!", "no hello here!"] each: |str| {
      match str {
        case /^hello (.*)$/ -> |_, name|
          name is_not == nil

        case _ -> name is == nil
      }
    }
  }
}
