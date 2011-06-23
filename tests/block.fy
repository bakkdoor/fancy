FancySpec describe: Block with: {
  it: "should return the value of the last expression" when: {
    block = {
      a = "a"
      empty = " "
      str = "String!"
      a ++ empty ++ str
    }
    block call is == "a String!"
  }

  it: "should close over a value and change it internally" when: {
    x = 0
    { x < 10 } while_true: {
      x is be: |x| { x < 10 }
      x = x + 1
    }
    x is == 10
  }

  it: "should return the argument count" for: 'arity when: {
    { } arity . is == 0
    |x| { } arity . is == 1
    |x y z| { } arity . is == 3
  }

  it: "should call a block while another is true" for: 'while_true: when: {
    i = 0
    {i < 10} while_true: {
      i = i + 1
    }
    i is be: { i >= 10 }
  }

  it: "should call a block while another is not true (boolean false)" for: 'while_false: when: {
    i = 0
    {i == 10} while_false: {
      i = i + 1
    }
    i is == 10
  }

  # again for while_nil
  it: "should call a block while another is nil" for: 'while_nil: when: {
    i = 0
    {i == 10} while_nil: {
      i = i + 1
    }
    i is == 10
  }

  it: "should call a block while another one is true-ish" for: 'while_do: when: {
    x = 0
    { x < 10 } while_do: |val| {
      val is == true
      x = x + 1
    }
  }

  it: "should call another block while a block yields false" for: 'until_do: when: {
    i = 0
    { i > 10 } until_do: { i <= 10 is == true; i = i + 1 }
    i is == 11
  }

  it: "should call a block until another yields true" for: 'until: when: {
    i = 0
    { i <= 10 is == true; i = i + 1 } until: { i > 10 }
    i is == 11
  }

  it: "should call itself only when the argument is nil" for: 'unless: when: {
    try {
      { StdError new: "got_run!" . raise! } unless: nil
      StdError new: "didnt_run!" . raise!
    } catch StdError => e {
      e message is == "got_run!"
    }
  }

  it: "should call itself only when the argument is true" for: 'if: when: {
    try {
      { StdError new: "got_run!" . raise! } if: true
      StdError new: "didnt_run!" . raise!
    } catch StdError => e {
      e message is == "got_run!"
    }
  }

  it: "should also be able to take arguments seperated by comma" for: 'call: when: {
    block = |x, y| { x + y }
    block call: [1,2] . is == 3
  }

  it: "should evaluate the blocks in a short-circuiting manner" for: '&& when: {
    { false } && { false } is == false
    { true } && { false } is == false
    { false } && { true } is == false
    { true } && { true } is == true

    { false } || { false } is == false
    { false } || { true } is == true
    { true } || { false } is == true
    { true } || { true } is == true

    # TODO: Add more useful tests here...
  }

  it: "should call the block as a partial block" when: {
    [1,2,3] map: @{upto: 3} . is == [[1,2,3], [2,3], [3]]
    [1,2,3] map: @{+ 3} . is == [4,5,6]
    [1,2,3] map: @{to_s} . is == ["1", "2", "3"]
    [1,2,3] map: @{to_s * 3} . is == ["111", "222", "333"]
  }

  it: "should execute a match clause if the block returns a true-ish value" for: '=== when: {
    def do_match: val {
      match val {
        case |x| { x even? } -> "yup, it's even"
        case _ -> "nope, not even"
      }
    }
    do_match: 2 . is == "yup, it's even"
    do_match: 1 . is == "nope, not even"
  }

  it: "should return the receiver of a block" for: 'receiver when: {
    class Foo { def foo { { self } } } # return block
    f = Foo new
    f foo receiver is == f
  }

  it: "should set the receiver correctly to a new value" for: 'receiver: when: {
    b = { "hey" }

    b receiver: 10
    b receiver is == 10

    b receiver: "Hello, World!"
    b receiver is == "Hello, World!"
  }

  it: "should call a block with a different receiver" for: 'call_with_receiver: when: {
    class ClassA {
      def inspect {
        "in ClassA#inspect"
      }
    }
    class ClassB {
      def inspect {
        "in ClassB#inspect"
      }
    }
    def self inspect {
      "in self#inspect"
    }
    block = {
      self inspect
    }
    block call is == "in self#inspect"
    block call_with_receiver: (ClassA new) . is == "in ClassA#inspect"
    block call_with_receiver: (ClassB new) . is == "in ClassB#inspect"
  }

  it: "should call a block with arguments and a different receiver" for: 'call:with_receiver: when: {
    class ClassC {
      def inspect: x {
        "in ClassC#inspect: #{x}"
      }
    }
    class ClassD {
      def inspect: x {
        "in ClassD#inspect: #{x}"
      }
    }
    def self inspect: x {
      "in self#inspect: #{x}"
    }
    block = |arg| {
      self inspect: arg
    }
    block call: [42] . is == "in self#inspect: 42"
    block call: [42] with_receiver: (ClassC new) . is == "in ClassC#inspect: 42"
    block call: [42] with_receiver: (ClassD new) . is == "in ClassD#inspect: 42"
  }

  it: "should call a block using the ruby-send syntax" for: 'call: when: {
    b = |x y| {
      x + y
    }

    b call: [2,3] . is == 5
    b(2,3) . is == 5

    b2 = |x| { x * 5 }
    b2("hello") is == ("hello" * 5)
    b2("foo") is == (b2 call: ["foo"])
  }
}
