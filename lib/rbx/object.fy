class Object {
  ruby_alias: '==
  ruby_alias: '===
  ruby_alias: 'class
  ruby_alias: 'inspect
  ruby_alias: 'object_id

  def initialize {
    initialize()
  }

  def require: file_path {
    """
    Loads and evaluates a given Fancy source file by trying to find the specified
    @file_path in Fancy's loadpath (see @Fancy::CodeLoader@).
    Relative paths are allowed (and by default expected).
    """
    Fancy CodeLoader require: file_path
  }

  def dclone {
    "Returns a deep clone of self using Ruby's Marshal class."
    Marshal load(Marshal dump(self))
  }

  def to_s {
    """
    @return @String@ represenation of @self.
    """

    to_s()
  }

  def set_slot: slotname value: val {
    """
    @slotname Name of slot to be set.
    @val Value for slot to be set.

    Sets an object's slot with a given value.
    """

    instance_variable_set("@" ++ slotname, val)
  }

  def get_slot: slotname {
    """
    @slotname Name of slot to get the value of.
    @return Value of slot with name @slotname.

    Returns the value of a slot of @self.
    """

    instance_variable_get("@" ++ slotname)
  }

  def define_singleton_method: name with: block {
    """
    @name Name of the method to be defined on @self.
    @block @Block@ to be used as the method's body.

    Dynamically defines a method on @self's metaclass (a singleton method) using a given @Block@.
    """

    metaclass define_method: name with: block
  }

  def undefine_singleton_method: name {
    """
    @name Name of the method to be undefined no @self's metaclass.

    Undefines a singleton method of @self.
    """

    metaclass undefine_method: name
  }

  def is_a?: class {
    """
    @class @Class@ to check for if @self is an instance of.
    @return @true if @self is an instance of @class, @false otherwise.

    Indicates, if an object is an instance of a given Class.
    """

    is_a?(class)
  }

  def kind_of?: class {
    """
    Same as Object#is_a?:
    Indicates, if an object is an instance of a given Class.
    """

    kind_of?(class)
  }

  def receive_message: message {
    """
    @message Name of message to be sent to @self dynamically.

    Dynamically sends a given message (without parameters) to @self.
    """

    send(message_name: message)
  }

  def receive_message: message with_params: params {
    """
    @message Name of message to be sent to @self dynamically.
    @params @Array@ of parameters used with @message.

    Dynamically sends a given message with parameters to @self.
    """

   ruby: (message_name: message) args: params
  }

  def message_name: symbol {
    symbol = symbol to_s
    match symbol =~ /:/ {
      case nil ->
        ":" ++ symbol
      case _ ->
        symbol
    }
  }

  def responds_to?: message {
    """
    @message The message to check for (preferably a Symbol).
    @return @true if @self responds to @message, @false otherwise.

    Indicates if an object responds to a given message.
    """

    respond_to?(message_name: message)
  }

  def extend: class {
    """
    @class @Class@ to extend @self with.

    Extends @self with the methods in @class (by including its methods in @self's metaclass).
    """

    metaclass include: class
  }
}
