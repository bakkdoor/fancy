FancySpec describe: Object with: |it| {
  it should: "dynamically evaluate a message-send with no arguments" when: {
    obj = 42;
    obj send: "to_s" . should_equal: "42"
  };

  it should: "dynamically evaluate a message-send with a list of arguments" when: {
    obj = "hello, world";
    obj send: "from:to:" params: [0,4] . should_equal: "hello"
  };

  it should: "dynamically define slotvalues" when: {
    obj = Object new;
    obj get_slot: :foo . should_equal: nil;
    obj set_slot: :foo value: "hello, world";
    obj get_slot: :foo . should_equal: "hello, world"
  };

  it should: "return its class" when: {
    nil _class should_equal: NilClass;
    true _class should_equal: TrueClass;
    "foo" _class should_equal: String;
    :bar _class should_equal: Symbol;
    { :a_block } _class should_equal: Block
  };

  it should: "call unkown_message:with_params: when calling an undefined method" when: {
    def class UnknownMessage {
      def unknown_message: message with_params: params {
        "Got: " ++ message ++ " " ++ params
      }
    };

    obj = UnknownMessage new;
    obj this_is_not_defined: "It's true!" . should_equal: "Got: this_is_not_defined: It's true!"
  };

  it should: "return a correct string representation" when: {
    3 to_s should_equal: "3";
    :foo to_s should_equal: "foo";
    nil to_s should_equal: ""
  };

  it should: "return a correct array representation" when: {
    nil to_a should_equal: [];
    :foo to_a should_equal: [:foo];
    <[:foo => "bar", :bar => "baz"]> to_a should_equal: [[:bar, "baz"], [:foo, "bar"]]
  };

  it should: "return a correct number representation" when: {
    nil to_num should_equal: 0;
    :foo to_num should_equal: 0;
    3 to_num should_equal: 3;
    3.28437 to_num should_equal: 3.28437
  };

  it should: "have no metadata initially" when: {
    o = Object new;
    o %M should_equal: nil
  };

  it should: "set the metadata correctly" when: {
    o = Object new;
    o %M: "foobar";
    o %M should_equal: "foobar"
  };

  it should: "be an Object of the correct Class (or Superclass)" when: {
    Object new is_a?: Object . should_equal: true;
    "foo" is_a?: String . should_equal: true;
    "foo" is_a?: Object . should_equal: true;
    1123 is_a?: Number . should_equal: true;
    1123 is_a?: Object . should_equal: true;
    132.123 is_a?: Number . should_equal: true;
    132.123 is_a?: Object . should_equal: true    
  };

  it should: "correctly assign multiple values at once" when: {
    x, y, z = 1, 10, 100;
    x should_equal: 1;
    y should_equal: 10;
    z should_equal: 100;

    x, y, z = :foo, :bar;
    x should_equal: :foo;
    y should_equal: :bar;
    z should_equal: nil;

    x = :foo;
    y = :bar;
    x, y = y, x;
    x should_equal: :bar;
    y should_equal: :foo
  }
}
