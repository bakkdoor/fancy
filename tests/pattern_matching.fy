FancySpec describe: "Pattern Matching" with: {
  it: "should match a value correctly by its class" when: {
    def do_match: obj {
      match obj -> {
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
    match "foobarbaz" -> {
      case r{foo([a-z]+)baz} -> |matcher|
        local1, local2, local3 = 'ignore, 'this_too, 'this_also
        matcher[1] should == "bar"
    }
  }
}
