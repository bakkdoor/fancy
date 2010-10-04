def class Hello {
  def hello {
    "Hello " ++ @name println
  }
}

def class World {
  include: Hello
  def initialize { @name = "World" }
}

World new hello
