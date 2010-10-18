def class Class {
  def alias_method: new for: old {
    alias_method: ~[new, old]
  }
}

def class String {
  alias_method: ":+" for: "+"
}

def class Class {
  def ruby_alias: method_name {
    alias_method: (":" + (method_name to_s)) for: method_name
  }
}

def class Object {

  ruby_alias: "=="

  def initialize {
    self initialize: ~[]
  }

  def dclone {
    "Returns a deep clone of self using Ruby's Marshal class."
    Marshal load: $ Marshal dump: self
  }

  def docstring: docstring {
    "Sets the docstring for an Object."
    @docstring = docstring
  }

  def docstring {
    "Returns the docstring for an Object."
    @docstring
  }

  def if_do: block {
    "If the object is non-nil, it calls the given block with itself as argument."

    self nil? if_false: {
      block call: [self]
    }
  }

  def ++ other {
    self to_s + (other to_s)
  }

  def to_s {
    self to_s: ~[]
  }

  def inspect {
    self inspect: ~[]
  }

  def set_slot: slotname value: val {
    instance_variable_set: ~["@" ++ slotname, val]
  }

  def get_slot: slotname {
    instance_variable_get: ~["@" ++ slotname]
  }

  def and: other {
    """
    Boolean conjunction.
    Returns true if self and other are true, otherwise nil.
    """

    self if_do: {
      other if_do: {
        return true
      }
    }
    return false
  }

  def or: other {
    """
    Boolean disjunction.
    Returns true if either self or other is true, otherwise nil.
    """
    self if_do: {
      return true
    } else: {
      other if_do: {
        return true
      }
    }
    return nil
  }

  def define_singleton_method: name with: block {
    self metaclass define_method: name with: block
  }

  def undefine_singleton_method: name {
    self metaclass remove_method: ~[name]
  }

  def is_a?: class {
    self is_a?: ~[class]
  }

  def send: message {
    self send: ~[message]
  }

  def responds_to?: message {
    self respond_to?: ~[message]
  }
}
