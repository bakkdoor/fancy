class Hello {
  def hello {
    "Hello " ++ @name println
  }
}

class World {
  include: Hello
  def initialize { @name = "World" }
}

World new hello
