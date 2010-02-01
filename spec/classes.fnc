# -*- coding: utf-8 -*-
# some code with class definitions etc:

class Bar {
  read_slots: [:name]
  def new: name {
    @name = name
  }
}

# everything following this will belong to the Foo.Bar package
package: Foo.Bar
import: [System]

class Foo < Bar {
  def new {
    super new: "Foo"
    private_method: "calling it!"
  }

  private: {
    def private_method: message {
      # without the upper import, it would be: System.Console
      Console writeln: "Got message: #{message}"
    }
  }
}

# now we're in the Bar.Baz package:
package: Bar.Baz

class Baz < Bar {
  def new {
    super new: "Baz"
    System.Console writeln: "Creating new instance of class Baz"
  }
}

package: Main
import: [System, Foo.Bar, Bar.Baz]

def get_positive: message {
  amount = 0
  { amount <=: 0 } while_true: {
    amount = (Console readln: message) to_num
  }
  amount
}

def main: args {
  foos = []
  (get_positive: "How many instances of Foo? (> 0)") times: {
    foos <<: (Foo new)
  }

  bazs = []
  (get_positive: "How many instances of Baz? (> 0)") times: {
    bazs <<: (Baz new)
  }

  (foos +: bazs) each: |x| {
    Console println: "Name of element: #{x name}"
  }
}
