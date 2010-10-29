class Class {
  """
  This class is the class of Class objects - e.g. Object, Array,
  String etc.
  Any class in the language is an instance of this class, as in Ruby
  or Smalltalk.
  """

  def define_slot_reader: slotname {
    "Defines a slot reader method with a given name."

    define_method: slotname with: {
      get_slot: slotname
    }
  }

  def define_slot_writer: slotname {
    "Defines a slot writer method with a given name."

    define_method: (slotname to_s + ":") with: |val| {
      set_slot: slotname value: val
    }
  }

  def read_slots: slots {
    "Defines slot reader methods for all given slotnames."

    slots each: |s| {
      define_slot_reader: s
    }
  }

  def write_slots: slots {
    "Defines slot writer methods for all given slotnames."

    slots each: |s| {
      define_slot_writer: s
    }
  }

  def read_write_slots: slots {
    "Defines slot reader & writer methods for all given slotnames."

    slots each: |s| {
      define_slot_reader: s
      define_slot_writer: s
    }
  }

  def subclass?: class_obj {
    "Indicates, if a Class is a subclass of another Class."

    self == class_obj if_true: {
      true
    } else: {
      # take care of Object class, as Object is its own superclass
      self superclass != nil if_true: {
        self superclass subclass?: class_obj
      }
    }
  }

  def alias_method: new_method_name for: old_method_name {
    "Defines an alias method for another method."
    define_method: new_method_name with: (self method: old_method_name)
  }

  def documentation: str {
     @_fancy_documentation = str
  }

  def documentation {
     @_fancy_documentation
  }
}
