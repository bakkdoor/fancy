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

def class ClassWithPrivate {
  def public_method {
    "public!"
  }

  def protected protected_method {
    "protected!"
  }
  
  def private private_method {
    "private!"
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
      self include: Mixin;
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
  };

  it should: "find the instance variable correctly" when: {
    def class AClass {
      def initialize: foo {
        @foo = foo
      }
      def foo {
        @foo
      }
    };

    str = "instance value";
    instance = AClass new: str;
    instance foo should_equal: str;
    AClass new foo should_not_equal: str
  };
  
  it should: "find the class variable correctly" when: {
    def class AClass {
      def foo: foo {
        @@foo = foo
      }
      def foo {
        @@foo
      }
    };

    instance1 = AClass new;
    instance2 = AClass new;
    str = "class value";
    instance1 foo: str;
    instance1 foo should_equal: str;
    instance2 foo should_equal: str;
    instance2 foo should_equal: $ instance1 foo;

    str2 = "another value";
    instance2 foo: str2;
    instance2 foo should_equal: str2;
    instance1 foo should_equal: str2
  };

  it should: "have correct method overloading for method names with and without an argument" when: {
    def class AClass {
      def foo {
        self foo: "None!"
      }

      def foo: bar {
        "In AClass#foo: with bar = " ++ bar
      }
    };

    instance = AClass new;
    instance foo should_equal: "In AClass#foo: with bar = None!";
    instance foo: "Test!" . should_equal: "In AClass#foo: with bar = Test!"
  };

  it should: "call superclass method by calling super" when: {
    def class SuperClass {
      self read_slots: [:name];
      def initialize: name {
        @name = name
      }
    };
    def class SubClass : SuperClass {
      self read_slots: [:age];

      def initialize: age {
        super initialize: "SubClass";
        @age = age
      }
    };

    sub = SubClass new: 42;
    sub name should_equal: "SubClass";
    sub age should_equal: 42
  };

  it should: "return its superclass" when: {
    Number superclass should_equal: Object;
    Symbol superclass should_equal: Object;
    Exception superclass should_equal: Object;
    Object superclass should_equal: Object;
    Class superclass should_equal: Object;

    IOError superclass should_equal: Exception;
    MethodNotFoundError superclass should_equal: Exception
  };

  it should: "create a new Class dynamically" when: {
    x = Class new;
    x is_a?: Class . should_equal: true;
    x new is_a?: x . should_equal: true;
    x new is_a?: Object . should_equal: true;
    x new _class should_equal: x;

    # Symbol as superclass
    y = Class new: Symbol;
    y is_a?: Class . should_equal: true;
    y new is_a?: Symbol . should_equal: true;
    y new is_a?: Object . should_equal: true
  };

  it should: "only be able to call the public method from outside the Class" when: {
    x = ClassWithPrivate new;
    x public_method should_equal: "public!";
    try {
      x private_method should_equal: nil # should fail
    } catch MethodNotFoundError => e {
      e method_name should_equal: "private_method"
    };
    try {
      x protected_method should_equal: nil # should fail
    } catch MethodNotFoundError => e {
      e method_name should_equal: "protected_method"
    }
  }
}
