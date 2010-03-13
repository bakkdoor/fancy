def class Bar {
  def foo {
    nil
  }
};

def class Foo < Bar {
  def initialize: name {
    @name = name
  }
};

def main: args {
  f = Foo new: "Chris"
}
