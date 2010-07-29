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
    instance normal_method . should == :normal_found;
    instance responds_to?: :normal_method . should == true;
    instance responds_to?: :mixin_method . should == nil
  };

  it should: "find the method when mixed-in" when: {
    # => include Mixin into ClassWithMixin
    def class ClassWithMixin {
      self include: Mixin;
    };

    instance = ClassWithMixin new;
    instance responds_to?: :normal_method . should == true;
    instance responds_to?: :mixin_method . should == true;
    instance normal_method . should == :normal_found;
    instance mixin_method . should == :mixed_in_found
  };

  it should: ("rebind the old class name with ClassWithNoMixin"
              + " and replace the old normal_method") when: {
    instance = ClassWithMixin new;
    instance normal_method should == :normal_found;
    # rebind the class to the other class
    ClassWithMixin = ClassWithNoMixin;
    instance = ClassWithMixin new;
    instance normal_method should == :new_normal_found
  };

  it should: "have dynamically generated getter methods" when: {
    instance = ClassWithNoMixin new;
    instance responds_to?: :foo . should == true;
    instance responds_to?: :bar . should == true;
    instance responds_to?: :baz . should == true;
    instance responds_to?: "hello:" . should == true;
    instance responds_to?: "world:" . should == true;
    instance responds_to?: :oh . should == true;
    instance responds_to?: "oh" . should == true;
    instance responds_to?: :noes . should == true;
    instance responds_to?: "noes:" . should == true
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
    instance foo should == str;
    AClass new foo should == nil
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
    instance1 foo should == str;
    instance2 foo should == str;
    instance2 foo should == (instance1 foo);

    str2 = "another value";
    instance2 foo: str2;
    instance2 foo should == str2;
    instance1 foo should == str2
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
    instance foo should == "In AClass#foo: with bar = None!";
    instance foo: "Test!" . should == "In AClass#foo: with bar = Test!"
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
    sub name should == "SubClass";
    sub age should == 42
  };

  it should: "return its superclass" when: {
    Number superclass should == Object;
    Symbol superclass should == Object;
    StdError superclass should == Object;
    Object superclass should == Object;
    Class superclass should == Object;

    IOError superclass should == StdError;
    MethodNotFoundError superclass should == StdError
  };

  it should: "create a new Class dynamically" when: {
    x = Class new;
    x is_a?: Class . should == true;
    x new is_a?: x . should == true;
    x new is_a?: Object . should == true;
    x new class should == x;

    # Symbol as superclass
    y = Class new: Symbol;
    y is_a?: Class . should == true;
    y new is_a?: Symbol . should == true;
    y new is_a?: Object . should == true
  };

  it should: "only be able to call the public method from outside the Class" when: {
    x = ClassWithPrivate new;
    x public_method should == "public!";
    try {
      x private_method should == nil # should fail
    } catch MethodNotFoundError => e {
      e method_name should == "private_method"
    };
    try {
      x protected_method should == nil # should fail
    } catch MethodNotFoundError => e {
      e method_name should == "protected_method"
    }
  };

  it should: "be a subclass of another Class" when: {
    def class Super {
    };
    def class Sub : Super {
    };

    Super subclass?: Object . should == true;
    Sub subclass?: Object . should == true;
    Sub subclass?: Super . should == true;
    Super subclass?: Sub . should == nil
  };

  it should: "dynamically create a subclass of another class" when: {
    subclass = String subclass: {
      def foo {
        "hello, world!"
      }
    };
    subclass is_a?: Class . should == true;
    subclass subclass?: String . should == true;
    subclass new is_a?: subclass . should == true;
    subclass new foo should == "hello, world!";

    # now the same with Class##new:body:
    subclass2 = Class superclass: Symbol body: {
      def foo {
        "hello, world, again!"
      }
    };
    subclass2 is_a?: Class . should == true;
    subclass2 subclass?: String . should == true;
    subclass2 new is_a?: subclass2 . should == true;
    subclass2 new foo should == "hello, world, again!"
  };

  it should: "undefine an instance method" when: {
    def class Foo {
      def instance_method {
      "instance method!"
      }
    };
    f = Foo new;
    f instance_method should == "instance method!";
    Foo undefine_method: :instance_method . should == true;
    try {
      f instance_method should == nil # should not get here
    } catch MethodNotFoundError => e {
      e method_name should == "instance_method"
    }
  };

  it should: "undefine a class method" when: {
    def class Foo {
      def self class_method {
      "class method!"
      }
    };
    Foo class_method should == "class method!";
    Foo undefine_method: :class_method . should == nil;
    Foo undefine_class_method: :class_method . should == true;
    try {
      Foo class_method should == nil # should not get here
    } catch MethodNotFoundError => e {
      e method_name should == "class_method"
    }
  };

  it should: "have nested classes" when: {
    def class Outer {
      def class Inner {
        def class InnerMost {
          def foobar {
            "foobar!"
          }
        }
      }
    };
    Outer is_a?: Class . should == true;
    Outer::Inner is_a?: Class . should == true;
    Outer::Inner::InnerMost is_a?: Class . should == true;
    obj = Outer::Inner::InnerMost new;
    obj foobar should == "foobar!";

    # change InnerMost#foobar
    def class Outer::Inner::InnerMost {
      def foobar {
        "oh no!"
      }
    };
    obj foobar . should == "oh no!"
  };

  it should: "not override existing classes with the same name in a nested class" when: {
    StdArray = Array;
    def class NameSpace {
      def class Array {
        def Array what_am_i {
          "not the same as the standard Array class"
        }
      }
    };

    NameSpace::Array what_am_i . should == "not the same as the standard Array class";
    NameSpace::Array should_not == Array
  }
}
