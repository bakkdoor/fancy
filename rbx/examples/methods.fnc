# A simple example of one method calling another in self.
def hello {
  "Hello " ++ $ self world
}

def world { "World" }


hello println
