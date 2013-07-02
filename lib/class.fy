class Class {
  """
  This class is the class of @Class@ objects - e.g. @Object@, @Array@,
  @String@ etc.
  Any class in the language is an instance of this class, as in Ruby
  or Smalltalk.
  """

  forwards_unary_ruby_methods

  alias_method: '__private__: for: 'private:
  alias_method: '__protected__: for: 'protected:
  alias_method: '__public__: for: 'public:

  def private: private_methods {
    """
    @private_methods @Block@ or @Fancy::Enumerable@ of method names to be private.

    Sets any given method names to private on this @Class@.

    Example:
          class MyClass {
            def foo {}
            def bar {}

            private: 'foo
            private: 'bar

            # same as:
            private: ('foo, 'bar)

            # same as:
            private: {
              def foo {}
              def bar {}
            }
          }
    """

    __private__: $ match private_methods {
      case Block ->
        methods = instance_methods: false
        private_methods call
        instance_methods: false - methods
      case _ -> private_methods
    }
  }

  def protected: protected_methods {
    """
    @protected_methods @Block@ or @Fancy::Enumerable@ of method names to be protected.

    Sets any given method names to protected on this @Class@.

    Example:
          class MyClass {
            def foo {}
            def bar {}

            protected: 'foo
            protected: 'bar

            # same as:
            protected: ('foo, 'bar)

            # same as:
            protected: {
              def foo {}
              def bar {}
            }
          }
    """

    __protected__: $ match protected_methods {
      case Block ->
        methods = instance_methods: false
        protected_methods call
        instance_methods: false - methods
      case _ -> protected_methods
    }
  }

  def public: public_methods {
    """
    @public_methods @Block@ or @Fancy::Enumerable@ of method names to be public.

    Sets any given method names to public on this @Class@.

    Example:
          class MyClass {
            def foo {}
            def bar {}

            public: 'foo
            public: 'bar

            # same as:
            public: ('foo, 'bar)

            # same as:
            public: {
              def foo {}
              def bar {}
            }
          }
    """

    __public__: $ match public_methods {
      case Block ->
        methods = instance_methods: false
        public_methods call
        instance_methods: false - methods
      case _ -> public_methods
    }
  }

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

  def remove_slot_accessors_for: slotnames {
    """
    @slotnames Name of slot or @Array@ of slotnames to remove accessor methods for.

    Removes both reader and writer methods for slots in @slotnames.
    """

    slotnames to_a each: |s| {
      try {
        undefine_method: s
      } catch NameError {}
      try {
        undefine_method: "#{s}:"
      } catch NameError {}
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

      class_eval: """
      def #{message_with_args} {
        @#{slotname} #{message_with_args}
      }
      """
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

  def ruby_instance_methods {
    """
    @return @Array@ of all instance methods defined in Ruby.
    """

    instance_methods - fancy_instance_methods
  }

  # dummy methods, get replaced at end of startup in lib/contracts.fy
  def provides_interface: methods {
    @provided_interface_methods = @provided_interface_methods to_a append: (methods to_a)
  }

  def expects_interface_on_inclusion: methods {
    @expected_interface_methods = methods to_a
  }
  alias_method: 'expects_interface: for: 'expects_interface_on_inclusion:

  def before_method: method_name run: block_or_method_name {
    """
    @method_name Name of @Method@ to run another @Method@ or @Block@ before, when called.
    @block_or_method_name @Block@ or name of other @Method@ to be called before @method_name.

    Runs / Calls @block_or_method everytime before running @method_name.

    Example:
          Array before_method: 'inspect run: 'compact!
          [1, nil, 2, nil, 3] inspect # => \"[1, 2, 3]\"

          # Or pass a Block:
          Array before_method: 'inspect run: @{ compact! }
    """

    define_calling_chain: [block_or_method_name, method_name] for_method: method_name
  }

  def after_method: method_name run: block_or_method_name {
    """
    @method_name Name of @Method@ to run another @Method@ or @Block@ after, when called.
    @block_or_method_name @Block@ or name of other @Method@ to be called after @method_name.

    Runs / Calls @block_or_method_name everytime after running @method_name.

    Example:
          Array after_method: 'inspect run: 'compact!
          x = [1, nil, 2, nil, 3]
          x inspect # => \"[1, nil, 2, nil, 3]\"
          x inspect # => \"[1, 2, 3]\"

          # Or pass a Block:
          Array after_method: 'inspect run: @{ compact! }
    """

    define_calling_chain: [method_name, block_or_method_name] for_method: method_name
  }

  def around_method: method_name run: block_or_method_name {
    """
    @method_name Name of @Method@ to run another @Method@ or @Block@ before & after, when called.
    @block_or_method_name @Block@ or name of other @Method@ to be called before & after @method_name.

    Runs / Calls @block_or_method_name everytime before & after running @method_name.

    Example:
          class MyController {
            def do_stuff {
              \"Doing stuff\" println
            }

            def log_data {
              \"Log data\" println
            }

            around_method: 'do_stuff run: 'log_data
          }

          controller = MyController new
          controller do_stuff

          # which will print:
          # Log data
          # Doing stuff
          # Log data

          # Or pass a Block:
          MyController around_method: 'do_stuff run: { \"Log data\" println }
    """

    define_calling_chain: [block_or_method_name, method_name, block_or_method_name] for_method: method_name
  }

  def define_calling_chain: blocks_or_method_names for_method: method_name {
    """
    @blocks_or_method_names @Array@ of either method names or @Block@s to be called in order.
    @method_name Name of method to define calling chain for.

    Example:
          class Foo {
            def foo { 'foo println }
            def bar { 'bar println }
            def baz { 'baz println }

            define_calling_chain: ['foo, 'bar, 'baz] for_method: 'foo
          }

          Foo new foo
          # prints:
          # foo
          # bar
          # baz

          # You can also pass in Blocks:
          Foo define_calling_chain: [@{ foo }, @{ bar }, @{ baz }] for_method: 'bar

          Foo new bar
          # prints:
          # foo
          # bar
          # baz
    """

    # optimize for methods if all arguments are symbols (generate code instead of using dynamic #call: messages)
    if: (blocks_or_method_names all?: @{ is_a?: Symbol }) then: {
      return define_method_calling_chain: blocks_or_method_names for_method: method_name
    }

    method = instance_method: method_name

    define_method: (method_name message_name) with: |args1| {
      bound_method = method bind(self)

      new_method_body = |args2| {
        match bound_method arity {
          case 0 -> args2 = []
          case 1 -> args2 = [args2]
        }

        args_with_self = args2 dup unshift: self
        return_val = nil
        blocks_or_method_names each: |block| {
          match block {
            case method_name -> return_val = bound_method call: args2
            case _ -> block call: args_with_self
          }
        }
        return_val
      }

      # define new method body and run it afterwards as we lazily
      # define the method the first time it's called for each new
      # instance of this class
      metaclass define_method: (method_name message_name) with: new_method_body

      match method arity {
        case 0 -> args1 = []
        case 1 -> args1 = [args1]
      }

      new_method_body call: args1
    }
  }

  def define_method_calling_chain: method_names for_method: method_name {
    orig_method_name = "__original__#{method_name}"
    alias_method: orig_method_name for: (method_name message_name)

    method = instance_method: (method_name message_name)
    orig_method = instance_method: orig_method_name

    before_methods = method_names take_while: |m| { m != method_name }
    _orig_method, *after_methods = method_names drop_while: |m| { m != method_name }

    before_methods = before_methods map: |m| { instance_method: m . selector_with_args } . join: ";"
    after_methods = after_methods map: |m| { instance_method: m . selector_with_args } . join: ";"

    class_eval: """
      def #{method selector_with_args} {
        #{before_methods}
        return_val = #{orig_method selector_with_args}
        #{after_methods}
        return_val
      }
    """
  }

  def rebind_instance_method: method_name with: rebind_callable within: within_block receiver: receiver (self) {
    """
    @method_name Name of instance method to rebind in @self.
    @rebind_callable Name of method or @Block@ to rebind @method_name to.
    @within_block @Block@ to be called with @receiver or @self.
    @receiver Argument to @within_block. Defaults to @self.
    @return Value of calling @within_block with @receiver.

    Rebinds @method_name to @rebind_callable within @within_block.
    If @within_block takes an argument, it will be called with @receiver (defaults to @self).
    """

    try {
      old_method = nil
      try {
        old_method = instance_method: method_name
      } catch NameError {}

      match rebind_callable {
        case Symbol -> alias_method: method_name for: rebind_callable
        case _ -> define_method: method_name with: rebind_callable
      }

      return within_block call: [receiver]
    } finally {
      if: old_method then: {
        define_method: method_name with: old_method
      } else: {
        undefine_method: method_name
      }
    }
  }

  def method_documentation: documentation_hash {
    """
    @documentation_hash @Hash@ of method name to documentation string.

    Sets documentation strings for methods defined in @documentation_hash.
    Useful for documenting methods without touching their implementation.

    Example:
          class SomeRubyLibraryClass {
            method_documentation: <[
              'some_method_a => \"Docstring A\",
              'some_method_b => \"Docstring B\"
            ]>
          }
    """

    documentation_hash each: |method_name doc| {
      instance_method: method_name . documentation: doc
    }
  }
}