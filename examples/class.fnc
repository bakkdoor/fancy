def class Bar {
  def say_hello: name {
    Console print: "Hello, ";
    Console println: name
  }
};

def class Foo < Bar {
  def initialize: name {
    Console println: "gonna set @name";
    @name = name
  };
  def say_hello {
    Console print: "Hello, ";
    Console println: @name
  }
};

# bar = Bar new;
# bar say_hello: "Chris";

foo = Foo new: "Chris from Constructor";
foo say_hello

