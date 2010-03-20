def class Bar {
  def initialize {
    Console println: "In Bar constructor!"
  };

  def say_hello: name {
    Console print: "Hello, ";
    Console println: name
  }
};

def class Foo : Bar {
  def initialize: name {
    Console println: "gonna set @name";
    @name = name
  };
  def say_hello {
    Console print: "Hello, ";
    Console println: @name;
    @block call
  };
  def on_hello_do: block {
    @block = block
  }
};

bar = (Bar new);
bar say_hello: "Chris";

foo = (Foo new: "Chris from Constructor");
# foo say_hello;
foo on_hello_do: {
  Console println: "Call me when calling on_hello! :)"
};
foo say_hello
