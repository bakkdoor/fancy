# -*- coding: utf-8 -*-
# some code with class definitions etc:

def class Bar {
  read_slots: [:name]
  def initialize: name {
    @name = name
  }
};

# everything following this will belong to the Foo::Bar package
package: Foo::Bar;
import: [System];

def class Foo < Bar {
  def initialize {
    super: "Foo";
    private_method: "calling it!"
  }

  private: {
    def private_method: message {
      # without the upper import, it would be: System::Console
      Console writeln: "Got message: #{message}"
    }
  }
};

# now we're in the Bar::Baz package:
package: Bar::Baz;

def class Baz < Bar {
  def initialize {
    super: "Baz";
    System::Console writeln: "Creating new instance of class Baz"
  }
};

package: Main;
import: [System, Foo::Bar, Bar::Baz];

def get_positive: message {
  amount = 0;
  { amount <= 0 } while_true: {
    amount = Console readln: message . to_num;
  };
  amount
}

# main programm starts here:
foos = [];
self get_positive: "How many instances of Foo? (> 0)" . times: {
  foos << Foo new
};

bazs = [];
self get_positive: "How many instances of Baz? (> 0)" . times: {
  bazs << Baz new
};

foos + bazs . each: |x| {
  Console println: "Name of element: #{x name}"
}
