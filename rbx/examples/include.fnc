def class Hello {
  def hello {
    "Hello " ++ (self name) . println
  }
}

def class World {
  include: Hello
  def name { "World" }
}

World new hello
