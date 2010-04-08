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

def class ClassWithNoMixin {
  self read_slots: [:foo, :bar, :baz];
  self write_slots: [:hello, :world];
  self read_write_slots: [:oh, :noes];
  
  def normal_method {
    :new_normal_found
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
  };

  it should: ("rebind the old class name with ClassWithNoMixin"
              + " and replace the old normal_method") when: {
    instance = ClassWithMixin new;
    instance normal_method should_equal: :normal_found;
    # rebind the class to the other class
    ClassWithMixin = ClassWithNoMixin;
    instance = ClassWithMixin new;
    instance normal_method should_equal: :new_normal_found
  };

  it should: "have dynamically generated getter methods" when: {
    instance = ClassWithNoMixin new;
    instance responds_to?: :foo . should_equal: true;
    instance responds_to?: :bar . should_equal: true;
    instance responds_to?: :baz . should_equal: true;
    instance responds_to?: "hello:" . should_equal: true;
    instance responds_to?: "world:" . should_equal: true;
    instance responds_to?: :oh . should_equal: true;
    instance responds_to?: "oh" . should_equal: true;
    instance responds_to?: :noes . should_equal: true;
    instance responds_to?: "noes:" . should_equal: true
  }
}
