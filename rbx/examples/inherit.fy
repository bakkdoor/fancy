class Hello {
  def hello {
    "Hello " ++ (self name) . println
  }
}

class World : Hello {
  def name { "World" }
}

World new hello
