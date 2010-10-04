def class Foo {
  def bar {
    Console println: "version 1"
  }
}

f = Foo new
f bar # prints: version 1

# redefine Foo#bar
def class Foo {
  def bar {
    Console println: "version 2"
  }
}

f bar # prints: version 2

# redefine Foo#bar again
def class Foo {
  def bar {
    Console println: "version 3"
  }
}

f bar # prints: version 3
