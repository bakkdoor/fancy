def class Bar {
  def say_hello: name {
    Console print: "Hello, ";
    Console println: name
  }
};

def class Foo < Bar {
  def initialize: name {
    @name = name
  }
};

f = Bar new;
f say_hello: "Chris"
