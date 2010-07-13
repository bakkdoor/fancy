FancySpec describe: Method with: |it| {
  it should: "return a Method object" when: {
    Array method: "each:" . class should_equal: Method
  };

  it should: "return the (correct) sender object of the MessageSend" when: {
    def class SenderTest {
      def give_me_the_sender! {
        __sender__
      }
    };

    x = SenderTest new;
    x give_me_the_sender! should_equal: self
  }
}
