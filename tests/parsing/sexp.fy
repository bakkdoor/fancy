FancySpec describe: "S-Expression" for: String with: {
  it: "should be correct for assignment" for: 'to_sexp when: {
    "x = 3" to_sexp should == ['exp_list, [['assign, ['ident, 'x], ['int_lit, 3]]]]
    "foobar = nil" to_sexp should == ['exp_list, [['assign, ['ident, 'foobar], ['ident, 'nil]]]]
  }

  it: "should be correct for symbol literals" for: 'to_sexp when: {
    "'foo" to_sexp should == ['exp_list, [['symbol_lit, 'foo]]]
  }

  it: "should be correct for string literals" for: 'to_sexp when: {
    #    "\"foo\"" to_sexp should == ['exp_list, [['string_lit, "foo"]]
  }

  it: "should be correct for integer literals" for: 'to_sexp when: {
    "3" to_sexp should == ['exp_list, [['int_lit, 3]]]
    "-3" to_sexp should == ['exp_list, [['int_lit, -3]]]
    "0" to_sexp should == ['exp_list, [['int_lit, 0]]]
  }

  it: "should be correct for double literals" for: 'to_sexp when: {
    "3.5" to_sexp should == ['exp_list, [['double_lit, 3.5]]]
    "-3.5" to_sexp should == ['exp_list, [['double_lit, -3.5]]]
    "0.0" to_sexp should == ['exp_list, [['double_lit, 0.0]]]
  }

  it: "should be correct for array literals" for: 'to_sexp when: {
    "[1,2,3]" to_sexp should == ['exp_list, [['array_lit, [['int_lit, 1], ['int_lit, 2], ['int_lit, 3]]]]]

    "[[1,2],[3,4]]" to_sexp should == .
    ['exp_list, [['array_lit, [['array_lit, [['int_lit, 1], ['int_lit, 2]]],
                               ['array_lit, [['int_lit, 3], ['int_lit, 4]]]]]]]

    "[]" to_sexp should == ['exp_list, [['array_lit, []]]]
  }

  it: "should be able to parse multiple expressions in one string" for: 'to_sexp when: {
    "x = 1; y = 2" to_sexp should == ['exp_list, [['assign, ['ident, 'x], ['int_lit, 1]],
                                                  ['assign, ['ident, 'y], ['int_lit, 2]]]]
  }

  it: "should parse an RubyArgsLiteral correctly" for: 'to_sexp when: {
    "obj foo: ~[1,2]" to_sexp should == .
    ['exp_list, [['message_send, ['ident, 'obj],
                  ['ident, 'foo:],
                  [['rb_args_lit, ['array_lit,
                                   [['int_lit, 1],
                                    ['int_lit, 2]]]]]]]]
  }
}
