FancySpec describe: Method with: {
  it: "should return a Method object" when: {
    [1,2,3] method: "each:" . class should == Method
  }

  # it: "should return the (correct) sender object of the MessageSend" when: {
  #   class SenderTest {
  #     def give_me_the_sender! {
  #       __sender__
  #     }
  #   }

  #   x = SenderTest new
  #   x give_me_the_sender! should == self
  # }

  it: "should return the amount of arguments a Method takes" for: 'argcount when: {
    class Foo {
      def no_args {
      }
      def one_arg: yo {
      }
      def two: a args: b {
      }
      def three: a args: b ok: c {
      }
    }

    Foo instance_method: 'no_args . arity should == 0
    Foo instance_method: "one_arg:" . arity should == 1
    Foo instance_method: "two:args:" . arity should == 2
    Foo instance_method: "three:args:ok:" . arity should == 3
  }

  it: "should return the return value" when: {
    def foo: bar {
      return "returning!"
      bar # will never get executed
    }

    foo: "yay" . should == "returning!"

    # another example

    def f: x {
      x < 10 if_true: {
        return 100
      }
      0
    }

    f: 10 . should == 0
    f: 9 . should == 100

    # and another one

    def foo {
      10 times: |i| {
        i == 8 if_true: {
          return i # nested return
        }
      }
      return 0
    }

    foo should == 8
  }

  it: "should return only from block-scope not from method-scope" when: {
    def self foo {
      10 times: |i| {
        i == 8 if_true: {
          return i
        }
      }
      0
    }
    foo should == 8
  }

  # it: "should return locally (from block-scope not from method-scope" when: {
  #   def self foo {
  #     [1,2,3] select: |x| { return_local x != 3 }
  #   }
  #   self foo should == [1,2]
  # }

  # class Foo {
  #   def bar {
  #   }
  #   def private private_bar {
  #   }
  #   def protected protected_bar {
  #   }
  # }

  # it: "should be public" for: 'public? when: {
  #   Foo method: 'bar . public? should == true
  #   Foo method: 'private_bar . public? should == nil
  #   Foo method: 'protected_bar . public? should == nil
  # }

  # it: "should be private" for: 'private? when: {
  #   Foo method: 'bar . private? should == nil
  #   Foo method: 'private_bar . private? should == true
  #   Foo method: 'protected_bar . private? should == nil
  # }

  # it: "should be protected" for: 'protected? when: {
  #   Foo method: 'bar . protected? should == nil
  #   Foo method: 'private_bar . protected? should == nil
  #   Foo method: 'protected_bar . protected? should == true
  # }

  it: "should set the default values for optional argument, when not passed in" when: {
    def foo: arg1 bar: arg2 ("foo") baz: arg3 (nil) {
      arg1 ++ arg2 ++ arg3
    }

    foo: "hello" bar: "world" baz: "!" . should == "helloworld!"
    foo: "hello" bar: "world" . should == "helloworld"
    foo: "hello"  . should == "hellofoo"
  }

  it: "should have default values for all arguments, if none given" when: {
    def a: arg1 ("foo") b: arg2 ("bar") c: arg3 ("baz") {
      [arg1, arg2, arg3]
    }

    a: "hello" b: "world" c: "!" . should == ["hello", "world", "!"]
    a: "hello" b: "world" . should == ["hello", "world", "baz"]
    a: "hello" . should == ["hello", "bar", "baz"]
    a should == ["foo", "bar", "baz"]
  }

  it: "should return multiple values (as a Tuple)" when: {
    def multiple_return_values: x {
      (x, x + x, x + x + x)
    }
    val = multiple_return_values: 3 . should == (3, 6, 9)
  }
}
