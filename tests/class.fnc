def class Mixin {
  def mixin_method {
    :mixed_in_found
  }
};

def class ClassWithMixin {
  def normal_method {
    :normal_found
  }
};

FancySpec describe: Class with: |it| {
  it should: "NOT find the method when not mixed-in" when: {
    instance = ClassWithMixin new;
    instance normal_method . should_equal: :normal_found;
    instance responds_to?: :normal_method . should_equal: true;
    instance responds_to?: :mixin_method . should_equal: nil
  };

  it should: "find the method when mixed-in" when: {
    # => include Mixin into ClassWithMixin
    def class ClassWithMixin {
      self include: Mixin
    };
    
    instance = ClassWithMixin new;
    instance responds_to?: :normal_method . should_equal: true;
    instance responds_to?: :mixin_method . should_equal: true;
    instance normal_method . should_equal: :normal_found;
    instance mixin_method . should_equal: :mixed_in_found
  }
}
