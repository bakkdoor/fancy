# methods.fy
# Examples of methods definitions, and method overriding in fancy

class Foo {
  def bar {
    Console println: "version 1"
  }
}

f = Foo new
f bar # prints: version 1

# redefine Foo#bar
class Foo {
  def bar {
    Console println: "version 2"
  }
}

f bar # prints: version 2

# redefine Foo#bar again
class Foo {
  def bar {
    Console println: "version 3"
  }
}

f bar # prints: version 3
