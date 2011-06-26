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

  it: "matches a Block as a pattern correctly" when: {
    def match_it: x {
      match x {
        case @{is_a?: String} -> 'string
        case @{is_a?: Symbol} -> 'symbol
        case @{responds_to?: 'each:} ->
          match x {
            case @{empty?} -> 'empty
            case _ -> 'not_empty
          }
        case Fixnum ->
          match x {
            case @{<= 3} -> '<=
            case _ -> x * 2
          }
        case _ -> x to_s * 2
      }
    }

    match_it: "hello, world!" is == 'string
    match_it: [] is == 'empty
    match_it: <[]> is == 'empty
    match_it: (Set new) is == 'empty
    match_it: (Stack new) is == 'empty
    match_it: [1,2,3] is == 'not_empty
    match_it: (1,"foo") is == 'not_empty
    match_it: <['foo => 'bar]> is == 'not_empty
    match_it: 'yo is == 'symbol
    match_it: 32 is == 64
    match_it: 4 is == 8
    match_it: 3 is == '<=
    match_it: 2 is == '<=
    match_it: 0 is == '<=
    match_it: -1 is == '<=
  }
}
