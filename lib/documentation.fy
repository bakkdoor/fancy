class Fancy Documentation {

  """
   Keeps a registry of documentation for anything Fancy.

   Provides methods for searching and formatting objects' docstrings
   this can be be handy for users of interactive Fancy REPL,
   document generators, instrospection toos, IDEs, anything!.
  """

  self for: (method('for:is:)) is: "Sets the documentation for obj."

  def self remove: obj {
    "Removes the documentation for obj."
    obj remove_instance_variable('@_fancy_documentation)
  }

  def self for: obj with_format: format = 'plain {
    """
      Obtains the documentation for obj.

      If format is specified, the documentation string will be
      converted using the corresponding formatter. This allows
      you to extend Fancy documentation system, and produce
      html documents, man pages, or anything you can imagine.
    """
    doc = obj instance_variable_get('@_fancy_documentation)
    formatter = self formatter: format
    formatter if_false: { "No such documentation format: " ++ format . raise! }
    formatter call: [doc]
  }

  def self formatter: name {
    "Obtain a formatter by the given name. Returns a callable object"
    self formatters at: name
  }

  def self formatter: name is: callable {
    "Register a callable object as formatter under name."
    self formatters at: name put: callable
  }

  def self formatters {
    "Obtain the hash of known documentation formatters."
    unless: @formatters do: { @formatters = <[ 'plain => |s| {s} ]> }
    @formatters
  }

}

class Fancy Documentation BlueCloth {

  "A documentation formatter using ruby's BlueCloth markdown"
  Fancy Documentation formatter: 'bluecloth is: |s| { bluecloth: s }

  # Register as default markdown formatter.
  Fancy Documentation formatter: 'markdown is: |s| { bluecloth: s }

  def self bluecloth: string {
    "Format string as HTML using BlueCloth ruby gem."
    require("rubygems")
    require("bluecloth")
    BlueCloth.new(string).to_html()
  }

}
