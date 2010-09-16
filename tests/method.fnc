FancySpec describe: Method with: |it| {
  it should: "return a Method object" when: {
    Array method: "each:" . class should == Method
  }

  it should: "return the (correct) sender object of the MessageSend" when: {
    def class SenderTest {
      def give_me_the_sender! {
        __sender__
      }
    }

    x = SenderTest new
    x give_me_the_sender! should == self
  }

  it should: "return the amount of arguments a Method takes" for: 'argcount when: {
    def class Foo {
      def no_args {
      }
      def one_arg: yo {
      }
      def two: a args: b {
      }
      def three: a args: b ok: c {
      }
    }

    Foo method: 'no_args . argcount should == 0
    Foo method: "one_arg:" . argcount should == 1
    Foo method: "two:args:" . argcount should == 2
    Foo method: "three:args:ok:" . argcount should == 3
  }

  it should: "return the return value" when: {
    def foo: bar {
      return: "returning!"
      bar # will never get executed
    }

    foo: "yay" . should == "returning!"

    # another example

    def f: x {
      x < 10 if_true: {
        return: 100
      }
      0
    }

    f: 10 . should == 0
    f: 9 . should == 100

    # and another one

    def foo {
      10 times: |i| {
        i == 8 if_true: {
          return: i # nested return
        }
      }
      return: 0
    }

    self foo should == 8
  }

  it should: "return only from block-scope not from method-scope" when: {
    define_singleton_method: "foo" with: {
      10 times: |i| {
        i == 8 if_true: {
          return: i
        }
      }
      0
    }
    self foo should == 8
  }
}
