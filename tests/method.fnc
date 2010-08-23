FancySpec describe: Method with: |it| {
  it should: "return a Method object" when: {
    Array method: "each:" . class should == Method
  };

  it should: "return the (correct) sender object of the MessageSend" when: {
    def class SenderTest {
      def give_me_the_sender! {
        __sender__
      }
    };

    x = SenderTest new;
    x give_me_the_sender! should == self
  };

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
    };

    Foo method: :no_args . argcount should == 0;
    Foo method: "one_arg:" . argcount should == 1;
    Foo method: "two:args:" . argcount should == 2;
    Foo method: "three:args:ok:" . argcount should == 3
  }
}
