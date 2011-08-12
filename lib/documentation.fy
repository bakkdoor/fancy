class Fancy Documentation {
  """
  A Fancy Documentation object is a holder for docstrings and specs.
  Keeps a registry of documentation for anything Fancy.

  Provides methods for searching and formatting an Object's docstrings.
  This can be be handy for users of the interactive Fancy REPL,
  document generators, instrospection tools, IDEs, anything!

  This object can be converted to just anything by using its format:
  method. Formatters can be registered with Fancy Documentation#formatter:is:

  By default two formatters are defined:

      'fancy    => Returns the Fancy::Documentation object
      'string   => Returns the docs string representation
  """

  read_write_slots: ['object, 'docs, 'specs]

  instance_method: 'docs . executable() . documentation: """
    An array of docstrings for the object beind documented.

    We have an array of docstrings because in Fancy, some
    things like classes can be re-openned and the user may
    specify new documentation for it each time. Thus we dont
    want to loose the previous documentation but rather build
    upon it. That is, fancy supports incremental documentation.
  """

  instance_method: 'specs . documentation: """
    An array of associated Fancy specs for the object
    being documented.

    Its a lot better to keep the associated specs in
    Fancy Documentation objects instead of just having them
    in method instances. This allows us to associate any object
    with an spec example.

    This way you can have a single Fancy spec example that
    is related to many objects (methods, constants, classes)
    that are being specified. Later in documentation, we can
    provide links to all specs where an object is being exercised.
  """

  def to_s {
    @docs join: "\n" . skip_leading_indentation
  }

  def format: format {
    """
    If format is specified, the documentation string will be
    converted using the corresponding formatter. This allows
    you to extend Fancy documentation system, and produce
    html documents, man pages, or anything you can imagine.
    """

    formatter = Fancy Documentation formatter: format
    { "No such documentation format: " ++ format . raise! } unless: formatter
    formatter call: [self]
  }

  def self for: obj append: docstring {
    """
    Append docstring to the documentation for obj.
    If obj has no documentation, one is created for it.
    """

    doc = for: obj
    if: doc then: {
      doc docs << docstring
    } else: {
      doc  = for: obj is: docstring
    }
    doc
  }

  def self formatter: name {
    """
    Obtains a formatter by a given name. Returns a callable object.
    """

    formatters at: name
  }

  def self formatter: name is: callable {
    """
    Registers a callable object as formatter under name.
    """

    formatters[name]: callable
  }

  def self formatters {
    """
    Obtain the hash of known documentation formatters.
    """

    unless: @formatters do: { @formatters = <[]> }
    @formatters
  }

  self formatter: 'fancy  is: |doc| { doc }
  self formatter: 'string is: |doc| { doc to_s }

  # TODO: implement. Plain is just like string but including spec names.
  self formatter: 'plain  is: |doc| { doc to_s }
}

class Fancy Documentation RDiscount {
  """
  A documentation formatter using ruby's RDiscount markdown
  """

  Fancy Documentation formatter: 'rdiscount is: |d| { rdiscount: d }

  # Register as default markdown formatter.
  Fancy Documentation formatter: 'markdown is: |d| { rdiscount: d }

  def self rdiscount: doc {
    "Format string as HTML using RDiscount ruby gem."
    require("rubygems")
    require("rdiscount")
    RDiscount new(doc to_s) to_html()
  }
}
