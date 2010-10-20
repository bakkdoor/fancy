class Bar {
  def initialize {
    Console println: "In Bar constructor!"
  }

  def say_hello: name {
    Console print: "Hello, "
    Console println: name
  }
}

class Foo : Bar {
  def initialize: name {
    Console println: "gonna set @name"
    @name = name
  }
  def say_hello {
    Console print: "Hello, "
    Console println: @name
    {@block call} if: @block
  }
  def on_hello_do: block {
    @block = block
  }
}

bar = Bar new
bar say_hello: "Chris"

foo = Foo new: "Chris from Constructor"
foo say_hello
foo on_hello_do: {
  Console println: "Call me when calling on_hello! :)"
}
foo say_hello

foo class println # print the class of foo

# define a singleton method on foo object
foo define_singleton_method: "foo!" with: {
  "In foo method :D" println
}

foo foo!

# define a 'normal' method on Foo class
# (instance method for all instances of Foo)
foo class define_method: "foo_for_all:" with: |x| {
  "In foo_for_all method (defined for all instances of Foo class)" println
  "Got argument: " ++ x println
}

foo2 = Foo new
foo2 foo_for_all: "hello, test! :)"
foo  foo_for_all: "hello, test (again)! :)"

# define a class method on Foo class
# it's the same as calling 'define_singleton_method:with:' on class
foo class define_class_method: "cool_class_method:" with: |arg| {
  "In class method for Foo! Argument given: " ++ arg println
}

# the following is the same as:
# foo class cool_class_method: "Some argument string"
Foo cool_class_method: "Some argument string"
