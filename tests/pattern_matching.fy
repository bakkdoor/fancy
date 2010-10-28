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
}
