FancySpec describe: Object with: {
  it: "should dynamically evaluate a message-send with no arguments" when: {
    obj = 42
    obj send_message: 'to_s . should == "42"
  }

  it: "should dynamically evaluate a message-send with a list of arguments" when: {
    obj = "hello, world"
    obj send_message: 'from:to: with_params: [0,4] . should == "hello"
  }

  it: "should dynamically define slotvalues" when: {
    obj = Object new
    obj get_slot: 'foo . should == nil
    obj set_slot: 'foo value: "hello, world"
    obj get_slot: 'foo . should == "hello, world"
  }

  it: "should undefine a singleton method" when: {
    def self a_singleton_method {
      "a singleton method!"
    }
    self a_singleton_method should == "a singleton method!"
    self undefine_singleton_method: 'a_singleton_method
    { self a_singleton_method } should raise: NoMethodError
  }

  it: "should return its class" when: {
    nil class should == NilClass
    true class should == TrueClass
    "foo" class should == String
    'bar class should == Symbol
    { 'a_block } class should == Block
  }

  it: "should call unkown_message:with_params: when calling an undefined method" when: {
    class UnknownMessage {
      def unknown_message: message with_params: params {
        "Got: " ++ message ++ " " ++ params
      }
    }

    obj = UnknownMessage new
    obj this_is_not_defined: "It's true!" . should == "Got: this_is_not_defined: It's true!"
  }

  it: "should return a correct string representation" when: {
    3 to_s should == "3"
    'foo to_s should == "foo"
    nil to_s should == ""
  }

  it: "should return a correct array representation" when: {
    nil to_a should == []
    'foo to_a should == ['foo]
    <['foo => "bar", 'bar => "baz"]> to_a should =? [['bar, "baz"], ['foo, "bar"]]
  }

  it: "should return a correct fixnum representation" when: {
    nil to_i should == 0
    3 to_i should == 3
    3.28437 to_i should == 3
  }

  it: "should be an Object of the correct Class (or Superclass)" when: {
    Object new is_a?: Object . should == true
    "foo" is_a?: String . should == true
    "foo" is_a?: Object . should == true
    1123 is_a?: Fixnum . should == true
    1123 is_a?: Object . should == true
    132.123 is_a?: Float . should == true
    132.123 is_a?: Object . should == true
  }

  # boolean messages

  it: "should be true for calling and: with non-nil values" for: 'and: when: {
    'foo and: 'bar . should == 'bar
  }

  it: "should be false for calling and: with a nil value" for: 'and: when: {
    'foo and: nil . should == nil
  }

  it: "should be true for calling && with non-nil values" for: '&& when: {
    ('foo && 'bar) should == 'bar
  }

  it: "should be false for calling && with a nil value" for: '&& when: {
    ('foo && nil) should == nil
  }


  it: "should be true for calling or: with any value" for: 'or: when: {
    'foo or: 'bar . should == 'foo
    'foo or: nil . should == 'foo
  }

  it: "should be true for calling || with any value" for: '|| when: {
    ('foo || 'bar) should == 'foo
    ('foo || nil) should == 'foo
  }

  # end boolean messages

  it: "should NOT be nil for non-nil values" for: 'nil? when: {
    'foo nil? should == false
    1 nil? should == false
    "hello" nil? should == false
  }

  it: "should NOT be false for non-nil values" for: 'false? when: {
    'foo false? should == false
    "hello, world" false? should == false
  }

  it: "should be true (true-ish)" for: 'true? when: {
    'foo true? should == true
    "hello, world" true? should == true
  }

  it: "should return the correct value" for: 'returning:do: when: {
    returning: [] do: |arr| {
      arr << 1
      arr << 2
      arr << 3
    } . should == [1,2,3]
  }

  it: "should only call a method if the receiver responds to it using a RespondsToProxy" for: 'if_responds? when: {
    class SomeClass {
      def some_method {
        'it_works!
      }
    }

    s = SomeClass new
    s if_responds? some_method should == 'it_works!
    s if_responds? some_undefined_method should == nil
  }

  it: "should call the backtick: method when using the '`' syntax" for: 'backtick: when: {
    `cat #{__FILE__}` should == (File read: __FILE__)

    # override backticks
    def backtick: str {
      str + " - NOT!"
    }

    `ls -al` should == "ls -al - NOT!"
  }
}
