FancySpec describe: Object with: {
  it: "should dynamically evaluate a message-send with no arguments" when: {
    obj = 42
    obj send_message: 'to_s . is == "42"
  }

  it: "should dynamically evaluate a message-send with a list of arguments" when: {
    obj = "hello, world"
    obj send_message: 'from:to: with_params: [0,4] . is == "hello"
  }

  it: "should dynamically define slotvalues" when: {
    obj = Object new
    obj get_slot: 'foo . is == nil
    obj set_slot: 'foo value: "hello, world"
    obj get_slot: 'foo . is == "hello, world"
  }

  it: "should undefine a singleton method" when: {
    def self a_singleton_method {
      "a singleton method!"
    }
    self a_singleton_method is == "a singleton method!"
    self undefine_singleton_method: 'a_singleton_method
    { self a_singleton_method } raises: NoMethodError
  }

  it: "should return its class" when: {
    nil class is == NilClass
    true class is == TrueClass
    "foo" class is == String
    'bar class is == Symbol
    { 'a_block } class is == Block
  }

  it: "should call unkown_message:with_params: when calling an undefined method" when: {
    class UnknownMessage {
      def unknown_message: message with_params: params {
        "Got: " ++ message ++ " " ++ params
      }
    }

    obj = UnknownMessage new
    obj this_is_not_defined: "It's true!" . is == "Got: this_is_not_defined: It's true!"
  }

  it: "should return a correct string representation" when: {
    3 to_s is == "3"
    'foo to_s is == "foo"
    nil to_s is == ""
  }

  it: "should return a correct array representation" when: {
    nil to_a is == []
    'foo to_a is == ['foo]
    <['foo => "bar", 'bar => "baz"]> to_a is =? [['bar, "baz"], ['foo, "bar"]]
  }

  it: "should return a correct fixnum representation" when: {
    nil to_i is == 0
    3 to_i is == 3
    3.28437 to_i is == 3
  }

  it: "should be an Object of the correct Class (or Superclass)" when: {
    Object new is_a?: Object . is == true
    "foo" is_a?: String . is == true
    "foo" is_a?: Object . is == true
    1123 is_a?: Fixnum . is == true
    1123 is_a?: Object . is == true
    132.123 is_a?: Float . is == true
    132.123 is_a?: Object . is == true
  }

  # boolean messages

  it: "should be true for calling and: with non-nil values" for: 'and: when: {
    'foo and: 'bar . is == 'bar
  }

  it: "should be false for calling and: with a nil value" for: 'and: when: {
    'foo and: nil . is == nil
  }

  it: "should be true for calling && with non-nil values" for: '&& when: {
    ('foo && 'bar) is == 'bar
  }

  it: "should be false for calling && with a nil value" for: '&& when: {
    ('foo && nil) is == nil
  }


  it: "should be true for calling or: with any value" for: 'or: when: {
    'foo or: 'bar . is == 'foo
    'foo or: nil . is == 'foo
  }

  it: "should be true for calling || with any value" for: '|| when: {
    ('foo || 'bar) is == 'foo
    ('foo || nil) is == 'foo
  }

  # end boolean messages

  it: "should NOT be nil for non-nil values" for: 'nil? when: {
    'foo nil? is == false
    1 nil? is == false
    "hello" nil? is == false
  }

  it: "should NOT be false for non-nil values" for: 'false? when: {
    'foo false? is == false
    "hello, world" false? is == false
  }

  it: "should not be true" for: 'true? when: {
    'foo true? is == false
    "hello, world" true? is == false
  }

  it: "should return the correct value" for: 'returning:do: when: {
    returning: [] do: |arr| {
      arr << 1
      arr << 2
      arr << 3
    } . is == [1,2,3]
  }

  it: "should only call a method if the receiver responds to it using a RespondsToProxy" for: 'if_responds? when: {
    class SomeClass {
      def some_method {
        'it_works!
      }
    }

    s = SomeClass new
    s if_responds? some_method is == 'it_works!
    s if_responds? some_undefined_method is == nil
  }

  it: "should call the backtick: method when using the '`' syntax" for: 'backtick: when: {
    `cat #{__FILE__}` is == (File read: __FILE__)

    # override backticks
    def backtick: str {
      str + " - NOT!"
    }

    `ls -al` is == "ls -al - NOT!"
  }

  it: "should override true and do some wacky stuff" for: 'true when: {
    class MyClass {
      def true {
        false
      }

      def do_wacky_things {
        4 == 5
      }
    }
    MyClass new do_wacky_things is == false

    {
      true is == false
    } call_with_receiver: (MyClass new)
  }

  it: "should override nil" for: 'nil when: {
    class MyClass {
      def nil {
        true
      }
    }

    { nil is == true } call_with_receiver: (MyClass new)
  }

  it: "should override false" for: 'false when: {
    class MyClass2 {
      def false {
        true
      }
    }

    { false is == true } call_with_receiver: (MyClass2 new)
  }

  it: "should implicitly send a message to self if no receiver specified" when: {
    def test { 42 }
    test is == 42
    self test is == 42
    test is == (self test)
  }
}
