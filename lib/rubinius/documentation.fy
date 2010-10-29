class Fancy Documentation {

  def self for: obj is: docstring {
    obj instance_variable_set('@_fancy_documentation, docstring)
  }

  def self for: obj {
    obj instance_variable_get('@_fancy_documentation)
  }

}

class Rubinius CompiledMethod {
  def documentation {
    Fancy Documentation for: self
  }
}

