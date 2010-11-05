class Fancy Documentation {

  def initialize: docstring {
    @docs = [docstring]
  }

  def meta: @meta { }
  def meta { @meta }

  # A list of handlers that would like to get adviced when
  # an object has been set documentation.
  @on_documentation_set = []

  def self on_documentation_set: block {
    @on_documentation_set.unshift(block)
  }

  def self documentation_for: obj set_to: doc {
    @on_documentation_set.each |block| { block call: [obj, doc] }
  }

  def self for: obj is: docstring {
    """
    Create a Fancy::Documentation instance.

    Note: As we're bootstrapping, we cannot set documentation here as
    an string literal.

    We are the very first thing to load, so just create a new
    Fancy::Documentation object without using new:, and set it as
    fancy docs.
    """

    doc = self allocate()
    doc send('initialize:, docstring to_s)
    obj instance_variable_set('@_fancy_documentation, doc)

    self documentation_for: obj set_to: doc
    doc
  }

  self for: (instance_method('initialize:)) is: "Create a new documentation object."
  self for: (method('for:is:)) is: "Sets the documentation for obj."

  def self for: obj {
    "Obtains the Fancy Documentation for obj."
    doc = obj instance_variable_get('@_fancy_documentation)
  }

  def self remove: obj {
    "Removes the documentation for obj."
    obj remove_instance_variable('@_fancy_documentation)
  }

  def self for: obj append: docstring {
    "Append docstring to docs."
    self for: obj is: docstring
  }

}

