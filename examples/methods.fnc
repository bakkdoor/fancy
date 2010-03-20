def class Foo {
  def bar {
    Console println: "version 1"
  }
};

f = (Foo new);
f bar;

def class Foo {
  def bar {
    Console println: "version 2"
  }
};

f bar;

def class Foo {
  def bar {
    Console println: "version 3"
  }
};

f bar
