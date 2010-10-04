# A simple example of one method calling another in self.
def hello {
  "Hello " ++ (self world)
}

def world { "World" }


self hello println

def hello_to: obj {
  "Hello, " ++ obj println
}

hello_to: "World!"
