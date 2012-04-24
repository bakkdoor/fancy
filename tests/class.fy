class Mixin {
  def mixin_method {
    'mixed_in_found
  }
}

class ClassWithMixin {
  def normal_method {
    'normal_found
  }
}

class ClassWithNoMixin {
  read_slots: ['foo, 'bar, 'baz]
  write_slots: ['hello, 'world]
  read_write_slots: ['oh, 'noes]

  def normal_method {
    'new_normal_found
  }
}

class ClassWithPrivate {
  def public_method {
    "public!"
  }

  def protected_method {
    "protected!"
  }
  protected: 'protected_method

  def private_method {
    "private!"
  }
  private: 'private_method
}

FancySpec describe: Class with: {
  it: "does NOT find the method when not mixed-in" with: 'responds_to?: when: {
    instance = ClassWithMixin new
    instance normal_method . is: 'normal_found
    instance responds_to?: 'normal_method . is: true
    instance responds_to?: 'mixin_method . is: false
  }

  it: "finds the method when mixed-in" with: 'include: when: {
    # => include Mixin into ClassWithMixin
    class ClassWithMixin {
      include: Mixin
    }

    instance = ClassWithMixin new
    instance responds_to?: 'normal_method . is: true
    instance responds_to?: 'mixin_method . is: true
    instance normal_method . is: 'normal_found
    instance mixin_method . is: 'mixed_in_found
  }

  it: "rebinds the old class name with ClassWithNoMixin and replace the old normal_method" when: {
    instance = ClassWithMixin new
    instance normal_method is: 'normal_found
    # rebind the class to the other class
    ClassWithMixin = ClassWithNoMixin
    instance = ClassWithMixin new
    instance normal_method is: 'new_normal_found
  }

  it: "has dynamically generated getter and setter methods" with: 'responds_to?: when: {
    instance = ClassWithNoMixin new
    instance responds_to?: 'foo . is: true
    instance responds_to?: 'bar . is: true
    instance responds_to?: 'baz . is: true
    instance responds_to?: "hello:" . is: true
    instance responds_to?: "world:" . is: true
    instance responds_to?: 'oh . is: true
    instance responds_to?: ":oh" . is: true
    instance responds_to?: 'noes . is: true
    instance responds_to?: "noes:" . is: true
  }

  it: "defines getter methods for single slots" with: 'read_slot: when: {
    class Getters {
      read_slot: 'foo
      read_slot: 'bar
    }

    g = Getters new
    g responds_to?: 'foo . is: true
    g responds_to?: 'foo: . is: false
    g responds_to?: 'bar . is: true
    g responds_to?: 'bar: . is: false
  }

  it: "defines setter methods for single slots" with: 'write_slot: when: {
    class Setters {
      write_slot: 'foo
      write_slot: 'bar
    }

    s = Setters new
    s responds_to?: 'foo . is: false
    s responds_to?: 'foo: . is: true
    s responds_to?: 'bar . is: false
    s responds_to?: 'bar: . is: true
  }

  it: "defines getter & setter methods for single slots" with: 'read_write_slot: when: {
    class GettersAndSetters {
      read_write_slot: 'foo
      read_write_slot: 'bar
    }

    gs = GettersAndSetters new
    gs responds_to?: 'foo . is: true
    gs responds_to?: 'foo: . is: true
    gs responds_to?: 'bar . is: true
    gs responds_to?: 'bar: . is: true
  }

  it: "finds the instance variable correctly" when: {
    class AClass {
      def initialize: foo {
        @foo = foo
      }
      def foo {
        @foo
      }
    }

    str = "instance value"
    instance = AClass new: str
    instance foo is: str
    AClass new foo is: nil
  }

  it: "finds the class variable correctly" when: {
    class AClass {
      def foo: foo {
        @@foo = foo
      }
      def foo {
        @@foo
      }
    }

    instance1 = AClass new
    instance2 = AClass new
    str = "class value"
    instance1 foo: str
    instance1 foo is: str
    instance2 foo is: str
    instance2 foo is: (instance1 foo)

    str2 = "another value"
    instance2 foo: str2
    instance2 foo is: str2
    instance1 foo is: str2
  }

  it: "has correct method overloading for method names with and without an argument" when: {
    class AClass {
      def foo {
        foo: "None!"
      }

      def foo: bar {
        "In AClass#foo: with bar = " ++ bar
      }
    }

    instance = AClass new
    instance foo is: "In AClass#foo: with bar = None!"
    instance foo: "Test!" . is: "In AClass#foo: with bar = Test!"
  }

  it: "calls a superclass method by using super" when: {
    class SuperClass {
      read_slots: ['name]
      def initialize: name {
        @name = name
      }
    }
    class SubClass : SuperClass {
      read_slots: ['age]

      def initialize: age {
        super initialize: "SubClass"
        @age = age
      }

      def initialize {
        initialize: 0
      }
    }

    sub = SubClass new: 42
    sub name is: "SubClass"
    sub age is: 42

    sub2 = SubClass new
    sub2 name is: "SubClass"
    sub2 age is: 0
  }

  it: "returns its superclass" when: {
    Fixnum superclass is: Integer
    Symbol superclass is: Object
    StdError superclass is: Exception
    Class superclass is: Module
    Object superclass is: nil

    IOError superclass is: StandardError
    NoMethodError superclass is: NameError
  }

  it: "creates a new Class dynamically" when: {
    x = Class new
    x is_a?: Class . is: true
    x new is_a?: x . is: true
    x new is_a?: Object . is: true
    x new class is: x

    # Symbol as superclass
    y = Class new: String
    y is_a?: Class . is: true
    y new is_a?: String . is: true
    y new is_a?: Object . is: true
  }

  it: "only is able to call the public method from outside the Class" when: {
    x = ClassWithPrivate new
    x public_method is: "public!"
    try {
      x private_method is: nil # is fail
    } catch NoMethodError => e {
      e method_name is: 'private_method
    }
    try {
      x protected_method is: nil # is fail
    } catch NoMethodError => e {
      e method_name is: 'protected_method
    }
  }

  it: "is a subclass of another Class" with: 'subclass?: when: {
    class Super {
    }
    class Sub : Super {
    }

    Super subclass?: Object . is: true
    Sub subclass?: Object . is: true
    Sub subclass?: Super . is: true
    Super subclass?: Sub . is: nil
  }

  it: "dynamically creates a subclass of another class" with: 'is_a?: when: {
    subclass = String subclass: {
      def foo {
        "hello, world!"
      }
    }
    subclass is_a?: Class . is: true
    subclass subclass?: String . is: true
    subclass new is_a?: subclass . is: true
    subclass new foo is: "hello, world!"

    # now the same with Class##new:body:
    subclass2 = Class superclass: String body: {
      def foo {
        "hello, world, again!"
      }
    }
    subclass2 is_a?: Class . is: true
    subclass2 subclass?: String . is: true
    subclass2 new is_a?: subclass2 . is: true
    subclass2 new foo is: "hello, world, again!"
  }

  it: "undefines an instance method" with: 'undefine_method: when: {
    class Foo {
      def instance_method {
        "instance method!"
      }
    }
    f = Foo new
    f instance_method is: "instance method!"
    Foo undefine_method: 'instance_method
    try {
      f instance_method is: nil # is not get here
    } catch NoMethodError => e {
      e method_name is: 'instance_method
    }
  }

  it: "undefines a class method" with: 'undefine_class_method: when: {
    class Foo {
      def self class_method {
        "class method!"
      }
    }
    Foo class_method is: "class method!"

    try {
      Foo undefine_method: 'class_method
      true is: nil # is not happen
    } catch NameError {
      true is: true
    }

    Foo undefine_class_method: 'class_method

    try {
      Foo class_method is: nil # is not get here
    } catch NoMethodError => e {
      e method_name is: 'class_method
    }
  }

  it: "has nested classes" when: {
    class Outer {
      class Inner {
        class InnerMost {
          def foobar {
            "foobar!"
          }
        }
      }
    }
    Outer is_a?: Class . is: true
    Outer Inner is_a?: Class . is: true
    Outer Inner InnerMost is_a?: Class . is: true
    obj = Outer Inner InnerMost new
    obj foobar is: "foobar!"

    # change InnerMost#foobar
    class Outer::Inner::InnerMost {
      def foobar {
        "oh no!"
      }
    }
    obj foobar is: "oh no!"
  }

  it: "does not override existing classes with the same name in a nested class" when: {
    StdArray = Array
    class NameSpace {
      class Array {
        def Array what_am_i {
          "not the same as the standard Array class"
        }
      }
    }

    NameSpace Array what_am_i is: "not the same as the standard Array class"
    NameSpace Array is_not: Array
  }

  # it: "returns all nested classes of a class" with: 'nested_classes when: {
  #   class Outer {
  #   }
  #   Outer nested_classes is: []

  #   class Outer {
  #     class Inner1 {
  #     }
  #   }
  #   Outer nested_classes is: [Outer::Inner1]

  #   class Outer {
  #     class Inner2 {
  #     }
  #   }
  #   Outer nested_classes is: [Outer Inner1, Outer Inner2]
  # }

  it: "finds other nested classes in the same parent class" when: {
    class MyOuter {
      class Inner1 {
        def method1 {
          'method_1
        }
      }
      class Inner2 {
        include: Inner1
        def method2 {
          'method_2
        }
      }
    }

    MyOuter Inner1 new method1 is: 'method_1
    MyOuter Inner2 new method1 is: 'method_1
    MyOuter Inner2 new method2 is: 'method_2
  }

  it: "finds itself in it's own methods, even if nested into another class" when: {
    class MyOuter {
      class MyInner1 {
        def method1 {
          MyInner1
        }
        def self class_method1 {
          MyInner1
        }
      }
      class MyInner2 {
        def method2 {
          [MyInner1, MyInner2]
        }
        def self class_method2 {
          [MyInner1, MyInner2]
        }
      }
    }

    MyOuter MyInner1 new method1 is: MyOuter MyInner1
    MyOuter MyInner2 new method2 is: [MyOuter MyInner1, MyOuter MyInner2]
    MyOuter MyInner1 class_method1 is: MyOuter MyInner1
    MyOuter MyInner2 class_method2 is: [MyOuter MyInner1, MyOuter MyInner2]
  }

  it: "has an alias method as defined" with: 'alias_method:for: when: {
    class AClass {
      def foo {
        "in foo!"
      }

      alias_method: 'bar for: 'foo
    }

    obj = AClass new
    obj foo is: "in foo!"
    obj bar is: "in foo!"
  }

  it: "has an alias method for a ruby method defined" with: 'alias_method:for_ruby: when: {
    try {
      [] equal?: [1,2] . is: true # is fail
    } catch NoMethodError => e {
      e method_name is: 'equal?:
    }

    class Array {
      alias_method: 'equal?: for_ruby: 'equal?
    }

    [] equal?: [1,2] . is: false
  }

  it: "has the correct list of ancestors" with: 'ancestors when: {
    class A {
    }
    class B : A {
    }
    class C : B {
    }

    A ancestors is: [A, Object, Kernel]
    B ancestors is: [B, A, Object, Kernel]
    C ancestors is: [C, B, A, Object, Kernel]
  }

  it: "makes methods private" with: 'private: when: {
    class AClassWithPrivateMethods {
      def a {
        "in a"
      }
      def b {
        "in b"
      }
      private: ['a, 'b]
    }

    x = AClassWithPrivateMethods new
    { x a } raises: NoMethodError
    { x b } raises: NoMethodError
    AClassWithPrivateMethods instance_method: 'a . private? is: true
    AClassWithPrivateMethods instance_method: 'b . private? is: true
  }

  it: "makes methods protected" with: 'protected: when: {
    class AClassWithProtectedMethods {
      def a {
        "in a"
      }
      def b {
        "in b"
      }
      protected: ['a, 'b]
    }

    x = AClassWithProtectedMethods new
    { x a } raises: NoMethodError
    { x b } raises: NoMethodError
    AClassWithProtectedMethods instance_method: 'a . private? is: false
    AClassWithProtectedMethods instance_method: 'b . private? is: false
    AClassWithProtectedMethods instance_method: 'a . protected? is: true
    AClassWithProtectedMethods instance_method: 'b . protected? is: true
  }

  it: "makes methods public" with: 'public: when: {
    class AClassWithPublicMethods {
      def a {
        "in a"
      }
      def b {
        "in b"
      }
      private: ['a, 'b]
      public: ['a, 'b] # making sure Class#public: works.
    }

    x = AClassWithPublicMethods new
    { x a } does_not raise: NoMethodError
    { x b } does_not raise: NoMethodError
    AClassWithPublicMethods instance_method: 'a . private? is: false
    AClassWithPublicMethods instance_method: 'b . private? is: false
    AClassWithPublicMethods instance_method: 'a . protected? is: false
    AClassWithPublicMethods instance_method: 'b . protected? is: false
    AClassWithPublicMethods instance_method: 'a . public? is: true
    AClassWithPublicMethods instance_method: 'b . public? is: true
  }

  it: "defines a class without a body" when: {
    class Foo
    Foo is_a?: Class . is: true
    Foo new is_a?: Foo . is: true

    class FooNew : Foo
    FooNew is_a?: Class . is: true
    FooNew ancestors includes?: Foo . is: true
    FooNew new is_a?: Foo . is: true
  }

  it: "defines a class with empty methods" when: {
    class Foo
    class Bar : Foo {
      def initialize: @bar
      def empty_method
      def to_s {
        @bar + "bar"
      }
    }

    b = Bar new: "foo"
    b to_s is: "foobar"
    b empty_method is: nil
  }

  class WithConstants {
    Foo = "foo"
    Bar = "bar"
    class Nested
  }

  it: "returns its nested constants" with: 'constants when: {
    WithConstants constants =? ["Foo", "Bar", "Nested"] is: true
  }

  it: "returns a constants value" with: '[] when: {
    WithConstants["Foo"] is: "foo"
    WithConstants["Foo"] is: WithConstants Foo
    WithConstants["Bar"] is: "bar"
    WithConstants["Bar"] is: WithConstants Bar
    WithConstants["Nested"] is_a?: Class . is: true
    WithConstants["Nested"] is: WithConstants Nested
  }

  it: "sets a constants value" with: '[]: when: {
    Kernel["Object"] is: Object
    { Kernel["Something"] } raises: NameError
    Kernel["Something"]: Array
    { Kernel["Something"] is: Array } does_not raise: NameError
  }

  it: "delegates methods correctly" with: 'delegate:to_slot: when: {
    class Delegation {
      delegate: ('[], '[]:, '<<, 'to_s, 'to_s:, 'inspect, 'each:in_between:) to_slot: 'object
      def initialize: @object
    }

    d = Delegation new: "hello, world!"
    d to_s is: "hello, world!"
    d inspect is: $ "hello, world!" inspect
    d = Delegation new: 2
    d to_s is: "2"
    d inspect is: "2"
    d to_s: 2 . is: "10"
    d = Delegation new: [1,2,3]
    d << 5
    d get_slot: 'object . is: [1,2,3,5]
    d << nil
    d get_slot: 'object . is: [1,2,3,5, nil]
    d[2]: "foo"
    d get_slot: 'object . is: [1,2,"foo",5,nil]
    d[1] is: 2
  }

  it: "allows delegating only a single method" with: 'delegate:to_slot: when: {
    class Delegation {
      delegate: 'to_s to_slot: 'number
      read_write_slot: 'number
    }

    d = Delegation new
    d number: 5
    d to_s is: $ 5 to_s
  }

  it: "defines a lazy slot" with: 'lazy_slot:value: when: {
    class LazyClass {
      lazy_slot: 'foo value: { Thread sleep: 0.01; 42 * @count }
      def initialize: @count
    }

    f = LazyClass new: 2
    start = Time now
    f foo is: 84
    Time now - start >= 0.01 is: true
    start = Time now
    f foo is: 84
    Time now - start <= 0.01 is: true
  }

  it: "returns a string representation of itself and its superclass, if any" with: 'inspect when: {
    class MySuperClass
    class MySubClass : MySuperClass

    Fixnum inspect is: "Fixnum : Integer"
    MySuperClass inspect is: "MySuperClass : Object"
    MySubClass inspect is: "MySubClass : MySuperClass"
    Object inspect is: "Object"
  }
}
