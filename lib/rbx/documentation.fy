class Fancy Documentation {

  def self for: obj is: docstring {
    obj instance_variable_set('@_fancy_documentation, docstring)
  }

  def self for: obj {
    obj instance_variable_get('@_fancy_documentation)
  }

}

class Fancy Documentation {

  """
   Keeps a registry of documentation for Fancy objects and filesjus.

   Provides methods for searching and formatting objects' docstrings
   this maybe be handy for users of interactive Fancy REPL.
  """

  self for: (method('for:is:)) is: "Sets the documentation for obj"
  self for: (method('for:)) is: "Obtains the documentation for obj"

}
