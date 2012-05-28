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

  def lazy_slot: slotname value: block {
    """
    @slotname Name of slot to be lazily set.
    @block @Block@ to be called to get the slot's lazy evaluated value.

    Defines a lazy getter for @slotname that yields the result of calling @block and caches it in @slotname.
    @block will be called with @self as the implicit receiver, so other slots can be used within @block.
    """

    define_method: slotname with: {
      unless: (get_slot: slotname) do: {
       set_slot: slotname value: $ block call_with_receiver: self
      }
      get_slot: slotname
    }
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

  def delegate: methods to_slot: slotname {
    """
    @methods @Fancy::Enumerable@ of method names to be delegated.
    @slotname Name of slot to delegate @methods to.

    Example:
          class MyClass {
            delegate: ('to_s, 'inspect) to_slot: 'my_slot
            def initialize: @my_slot
          }

          m = MyClass new: [1, 2, 3]
          m to_s      # => \"123\"
          m inspect   # => \"[1, 2, 3]\"
    """
    { methods = methods to_a } unless: $ methods is_a?: Fancy Enumerable

    methods each: |m| {
      keywords = m to_s split: ":"
      message_with_args = ""

      match m to_s {
        case "[]" -> message_with_args = "[arg]"
        case "[]:" -> message_with_args = "[arg1]: arg2"
        case _ ->
          keywords map_with_index: |kw i| {
            if: (kw =~ /[a-zA-Z]/) then: {
              if: (m to_s includes?: ":") then: {
                message_with_args << "#{kw}: arg_#{i}"
              } else: {
                message_with_args << kw
              }
            } else: {
              message_with_args << "#{kw} arg_#{i}"
            }
            message_with_args <<  " "
          }
      }

      mdef = "def #{message_with_args}"

      mdef << " {\n"
      mdef << "@#{slotname} #{message_with_args}"

      mdef << "\n}"

      class_eval: {
        mdef eval
      }
    }
  }

  def inspect {
    """
    @return Name of class and its superclass as a @String@.

    Example:
          Fixnum inspect # => \"Fixnum : Integer\"
          Object inspect # => \"Object\"
    """

    if: superclass then: {
      "#{name} : #{superclass}"
    } else: {
      name
    }
  }

  def fancy_instance_methods {
    """
    @return @Array@ of all instance methods defined in Fancy.
    """

    instance_methods select: @{ includes?: ":" }
  }

  def fancy_methods {
    """
    @return @Array@ of all class methods defined in Fancy.
    """

    methods select: @{ includes?: ":" }
  }

  def ruby_instance_methods {
    """
    @return @Array@ of all instance methods defined in Ruby.
    """

    instance_methods - fancy_instance_methods
  }

  def ruby_methods {
    """
    @return @Array@ of all class methods defined in Ruby.
    """

    methods - fancy_methods
  }

  # dummy methods, get replaced at end of startup in lib/contracts.fy
  def provides_interface: methods {
    @provided_interface_methods = @provided_interface_methods to_a append: (methods to_a)
  }

  def expects_interface_on_inclusion: methods {
    @expected_interface_methods = methods to_a
  }
}
