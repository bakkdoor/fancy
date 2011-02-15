FancySpec describe: "Pattern Matching" with: {
  it: "should match a value correctly by its class" when: {
    def do_match: obj {
      match obj {
        case String -> 'string
        case Fixnum -> 'fixnum
        case _ -> 'anything
      }
    }

    do_match: "foo" . should == 'string
    do_match: 42 . should == 'fixnum
    do_match: 'symbol . should == 'anything
    do_match: Object . should == 'anything
    do_match: 32.32 . should == 'anything
  }

  it: "should bind a given match arg, if present, to the result of the match operation" when: {
    match "foobarbaz" {
      case /foo([a-z]+)baz/ -> |matcher|
        local1, local2, local3 = 'ignore, 'this_too, 'this_also
        matcher[1] should == "bar"
    }
  }

  it: "should only bind given match arg to the scope of the match case" when: {
    match "foobarbaz" {
      case /foo([a-z]+)baz/ -> |local_of_case|
        local_of_case == nil . should == false
    }

    local_of_case should == nil
  }

  it: "should only bind locals of the match clause to the scope of the match case" when: {
    match "foobarbaz" {
      case /foo([a-z]+)baz/ -> |local_of_case|
        local1 = "Hi, I am some local, that should be gone after this block."
    }

    local1 should == nil
  }

  it: "should bind any additional match args to the matched values" when: {
    str = "foo bar baz"
    match str {
      case /^foo (.*) (.*)$/ -> |all, match1, match2|
      all class should == MatchData
      match1 should == "bar"
      match2 should == "baz"
    }
  }

  it: "should return an instance of the apropriate MatchData class" when: {
    def create_tuple: num {
      (num, num * num) # create a Tuple
    }

    match create_tuple: 10 {
      case Tuple -> |md, x, y, z|
        # convention: md[0] always holds the entire object that was matched.
        md[0] should == (create_tuple: 10)
        x should == 10
        y should == 100
        z should == nil # tuple only has 2 entries
    }
  }

  it: "should match an array correctly" when: {
    def create_array: num {
      [num, num ** 2, num ** 3, num ** 4]
    }

    match create_array: 2 {
      case Array -> |_, a,b,c,d|
        a should == 2
        b should == (2 ** 2)
        c should == (2 ** 3)
        d should == (2 ** 4)
    }
  }

  it: "should not try to bind the match args if the match failed" when: {
    ["hello world!", "hello you!", "no hello here!"] each: |str| {
      match str {
        case /^hello (.*)$/ -> |_, name|
          name should_not == nil

        case _ -> name should == nil
      }
    }
  }
}
