FancySpec describe: Object with: {
  it: "dynamically evaluates a message-send with no arguments" when: {
    obj = 42
    obj receive_message: 'to_s . is: "42"
  }

  it: "dynamically evaluates a message-send with a list of arguments" when: {
    obj = "hello, world"
    obj receive_message: 'from:to: with_params: [0,4] . is: "hello"
  }

  it: "dynamically defines slotvalues" when: {
    obj = Object new
    obj get_slot: 'foo . is: nil
    obj set_slot: 'foo value: "hello, world"
    obj get_slot: 'foo . is: "hello, world"
  }

  it: "undefines a singleton method" when: {
    def self a_singleton_method {
      "a singleton method!"
    }
    self a_singleton_method is: "a singleton method!"
    self undefine_singleton_method: 'a_singleton_method
    { self a_singleton_method } raises: NoMethodError
  }

  it: "returns its class" when: {
    nil class is: NilClass
    true class is: TrueClass
    "foo" class is: String
    'bar class is: Symbol
    { 'a_block } class is: Block
  }

  it: "calls unkown_message:with_params: when calling an undefined method" when: {
    class UnknownMessage {
      def unknown_message: message with_params: params {
        "Got: " ++ message ++ " " ++ params
      }
    }

    obj = UnknownMessage new
    obj this_is_not_defined: "It's true!" . is: "Got: this_is_not_defined: It's true!"
  }

  it: "returns a correct string representation" when: {
    3 to_s is: "3"
    'foo to_s is: "foo"
    nil to_s is: ""
  }

  it: "returns a correct array representation" when: {
    nil to_a is: []
    'foo to_a is: ['foo]
    <['foo => "bar", 'bar => "baz"]> to_a is =? [['bar, "baz"], ['foo, "bar"]]
  }

  it: "returns a hash based on own slot values" with: 'to_hash when: {
    nil to_hash is: <[]>
    false to_hash is: <[]>
    true to_hash is: <[]>
    (0..10) each: @{ to_hash is: <[]> }
  }

  it: "returns a correct fixnum representation" with: 'to_i when: {
    nil to_i is: 0
    3 to_i is: 3
    3.28437 to_i is: 3
  }

  it: "is an Object of the correct Class (or Superclass)" when: {
    Object new is_a?: Object . is: true
    "foo" is_a?: String . is: true
    "foo" is_a?: Object . is: true
    1123 is_a?: Fixnum . is: true
    1123 is_a?: Object . is: true
    132.123 is_a?: Float . is: true
    132.123 is_a?: Object . is: true
  }

  # boolean messages

  it: "is true for calling and: with non-nil values" with: 'and: when: {
    'foo and: 'bar . is: 'bar
  }

  it: "is false for calling and: with a nil value" with: 'and: when: {
    'foo and: nil . is: nil
  }

  it: "is true for calling && with non-nil values" with: '&& when: {
    ('foo && 'bar) is: 'bar
  }

  it: "is false for calling && with a nil value" with: '&& when: {
    ('foo && nil) is: nil
  }


  it: "is true for calling or: with any value" with: 'or: when: {
    'foo or: 'bar . is: 'foo
    'foo or: nil . is: 'foo
  }

  it: "is true for calling || with any value" with: '|| when: {
    ('foo || 'bar) is: 'foo
    ('foo || nil) is: 'foo
  }

  it: "is true if only one of them is not true" with: 'xor: when: {
    true xor: false . is: true
    false xor: false . is: false
    nil xor: nil . is: false
    false xor: false . is: false
    false xor: nil . is: false
    1 xor: nil . is: true
  }

  # end boolean messages

  it: "is not nil for non-nil values" with: 'nil? when: {
    'foo nil? is: false
    1 nil? is: false
    "hello" nil? is: false
  }

  it: "is not false for non-nil values" with: 'false? when: {
    'foo false? is: false
    "hello, world" false? is: false
  }

  it: "is not true" with: 'true? when: {
    'foo true? is: false
    "hello, world" true? is: false
  }

  it: "returns the correct value" with: 'returning:do: when: {
    returning: [] do: |arr| {
      arr << 1
      arr << 2
      arr << 3
    } . is: [1,2,3]
  }

  it: "only calls a method if the receiver responds to it using a RespondsToProxy" with: 'if_responds? when: {
    class SomeClass {
      def some_method {
        'it_works!
      }
    }

    s = SomeClass new
    s if_responds? some_method is: 'it_works!
    s if_responds? some_undefined_method is: nil
  }

  it: "calls the backtick: method when using the '`' syntax" with: 'backtick: when: {
    `cat #{__FILE__}` is: (File read: __FILE__)

    # override backticks
    def backtick: str {
      str + " - NOT!"
    }

    `ls -al` is: "ls -al - NOT!"
  }

  it: "overrides true and does some wacky stuff" with: 'true when: {
    class MyClass {
      def true {
        false
      }

      def do_wacky_things {
        4 == 5
      }
    }
    MyClass new do_wacky_things is: false

    @{ true is: false } call: [MyClass new]
  }

  it: "overrides nil" with: 'nil when: {
    class MyClass {
      def nil {
        true
      }
    }

    @{ nil is: true } call: [MyClass new]
  }

  it: "overrides false" with: 'false when: {
    class MyClass2 {
      def false {
        true
      }
    }

    @{ false is: true } call: [MyClass2 new]
  }

  it: "implicitly sends a message to self if no receiver is specified" when: {
    def test { 42 }
    test is: 42
    self test is: 42
    test is: (self test)
  }

  it: "calls a given block in the context of the receiver (like a message cascade)" with: 'do: when: {
    arr = []
    arr do: {
      << 1
      << 2
      << 3
      select!: 'even?
    }
    arr is: [2]
    arr do: {
      is: [2] # same
    }
  }

  it: "calls a given block with self if the block takes an argument" with: 'do: when: {
    arr = []
    arr do: @{
      << 1
      << 2
      << 3
      select!: 'even?
    } . is: [2]

    arr do: @{
      is: [2] # same
    }

    2 do: @{ inspect } . is: 2
  }

  it: "calls a given block with the receiver before returning itself" with: 'tap: when: {
    10 + 2 tap: |x| {
      x is: 12
      x is_a?: Number . is: true
    } . is: 12

    "foo" + "bar" tap: @{ is: "foobar"; * 2 is: "foobarfoobar" } . is: "foobar"
  }

  it: "returns an array of its slot names" with: 'slots when: {
    class GotSlots {
      def initialize {
        @x, @y = 1, 2
      }
      def set_another_slot {
        @z = 123
      }
    }
    gs = GotSlots new
    Set[gs slots] is: $ Set[['x, 'y]]
    gs set_another_slot
    Set[gs slots] is: $ Set[['x,'y,'z]]
  }

  it: "copies a given list of slots from one object to another" with: 'copy_slots:from: when: {
    o1 = { slot1: "foo" slot2: "bar" } to_object
    o2 = {} to_object
    o2 copy_slots: ['slot1] from: o1
    o2 slots includes?: 'slot1 . is: true
    o2 get_slot: 'slot1 == (o1 slot1) is: true
  }

  it: "copies all slots from one object to another" with: 'copy_slots_from: when: {
    o1 = { slot1: "foo" slot2: "bar" } to_object
    o2 = {} to_object
    o2 slots is: []
    o2 copy_slots_from: o1
    o2 slots includes?: 'slot1 . is: true
    o2 slots includes?: 'slot2 . is: true
    o2 slots is: $ o1 slots
    o2 get_slot: 'slot1 == (o1 slot1) is: true
    o2 get_slot: 'slot2 == (o1 slot2) is: true
  }

  it: "returns itself when return is send as a message" when: {
    def foo: array {
      array each: @{ return }
    }
    foo: [1,2,3] . is: 1

    def bar: array values: vals {
      array each: |x| {
        vals << x
        x return
      }
    }

    v = []
    bar: [1,2,3] values: v . is: 1
    v is: [1]
  }

  it: "provides temporarily mutable slots" with: 'with_mutable_slots:do: when: {
    class Student {
      read_slots: ('name, 'age, 'city)
      def initialize: block {
        with_mutable_slots: ('name, 'age, 'city) do: block
      }
    }

    p = Student new: @{
      name: "Chris"
      age: 24
      city: "Osnabrück"
    }

    p name is: "Chris"
    p age is: 24
    p city is: "Osnabrück"

    { p name: "New Name" } raises: NoMethodError
    { p age: 25 } raises: NoMethodError
    { p city: "New City" } raises: NoMethodError

    # no changes
    p name is: "Chris"
    p age is: 24
    p city is: "Osnabrück"
  }

  it: "ignores all specified exception types" with: 'ignoring:do: when: {
    {
      [{ 2 / 0 }, { "foo" unknown_method_on_string! }] each: |b| {
        ignoring: (ZeroDivisionError, NoMethodError) do: b
      }
    } does_not raise: Exception
  }

  it: "rebinds a singleton method within a block" with: 'rebind_method:with:within: when: {
    s = "foo"
    s rebind_method: 'hello with: { 42 } within: {
      s hello is: 42
    }

    s rebind_method: 'hello with: 'to_s within: {
      s hello is: "foo"
    }

    { s hello } raises: NoMethodError

    def s bar {
      "bar!"
    }

    s bar is: "bar!"

    s rebind_method: 'bar with: { "new bar!" } within: {
      s bar is: "new bar!"
    }

    s rebind_method: 'bar with: { "another bar!" } within: |x| { x bar } . is: "another bar!"

    s bar is: "bar!"
  }

  it: "binds a dynvar correctly" with: 'let:be:in:ensuring: when: {
    *var* is: nil
    let: '*var* be: 'hello in: {
      *var* is: 'hello
    } ensuring: {
      *var* is: 'hello
    }
    *var* is: nil

    @val = nil
    def check {
      *var* is: @val
    }

    check
    @val = "test"
    let: '*var* be: @val in: {
      check
    }
    @val = nil
    check
  }
}
