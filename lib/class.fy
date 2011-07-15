class Class {
  """
  This class is the class of @Class@ objects - e.g. @Object@, @Array@,
  @String@ etc.
  Any class in the language is an instance of this class, as in Ruby
  or Smalltalk.
  """

  forwards_unary_ruby_methods

  def define_slot_reader: slotname {
    """
    @slotname Name of the slot to define a getter method for.

    Defines a slot reader method with a given name.
    E.g. for a slotname @count it will define the following method:
        def count {
          get_slot: 'count
        }
    """

    define_method: slotname with: {
      get_slot: slotname
    }
  }

  def define_slot_writer: slotname {
    """
    @slotname Name of the slot to defnie define a setter method for.

    Defines a slot writer method with a given name.
    E.g. for a slotname @count it will define the following method:
        def count: c {
          set_slot: 'count value: c
        }
    """

    define_method: (slotname to_s + ":") with: |val| {
      set_slot: slotname value: val
    }
  }

  def read_slots: slots {
    """
    @slots @Array@ of slotnames to define getter methods for.

    Defines slot reader methods for all given slotnames.
    """

    slots each: |s| {
      define_slot_reader: s
    }
  }

  def read_slot: slotname {
    """
    @slotname Name of slot to define a getter method for.

    Defines a slot reader method for a given slotname.
    """

    define_slot_reader: slotname
  }

  def write_slots: slots {
    """
    @slots @Array@ of slotnames to define setter methods for.

    Defines slot writer methods for all given slotnames.
    """

    slots each: |s| {
      define_slot_writer: s
    }
  }

  def write_slot: slotname {
    """
    @slotname Name of slot to define a setter method for.

    Defines a slot writer method for a given slotname.
    """

    define_slot_writer: slotname
  }

  def read_write_slots: slots {
    """
    @slots @Array@ of slotnames to define getter & setter methods for.

    Defines slot reader & writer methods for all given slotnames.
    """

    slots each: |s| {
      define_slot_reader: s
      define_slot_writer: s
    }
  }

  def read_write_slot: slotname {
    """
    @slotname Name of slot to define getter & setter methods for.

    Defines slot reader & writer methods for a given slotname.
    """

    define_slot_reader: slotname
    define_slot_writer: slotname
  }

  def subclass?: class_obj {
    """
    @class_obj Class object to check for, if @self is a subclass of @class_obj.
    @return @true, if @self is a subclass of @class_obj, @false otherwise.

    Indicates, if a Class is a subclass of another Class.
    """

    if: (self == class_obj) then: {
      true
    } else: {
      # take care of Object class, as Object is its own superclass
      unless: (superclass nil?) do: {
        superclass subclass?: class_obj
      }
    }
  }

  def alias_method: new_method_name for: old_method_name {
    """
    @new_method_name New method name to be used as an alias for @old_method_name.
    @old_method_name Name of method to alias (must exist in the @Class@).

    Defines an alias method for another method.
    """

    alias_method_rbx: new_method_name for: old_method_name
  }
}
