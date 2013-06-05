class Class {
  ruby_aliases: [ 'superclass, '===, 'ancestors, 'instance_methods, 'methods, 'to_s ]

  def new {
    """
    @return A new instance of @Class@ @self.

    Creates a new instance of @self calling @initialize.
    """

    obj = allocate()
    obj initialize
    obj
  }

  # calls initialize:, if defined
  def new: arg {
    """
    @arg Argument to @initialize:.
    @return A new instance of @Class@ @self.

    Creates a new instance of @self calling @initialize:.
    """

    obj = allocate()
    obj initialize: arg
    obj
  }

  def Class superclass: superclass body: body_block {
    """
    @superclass The superclass to inherit from.
    @body_block A @Block@ that is used as the body of the new @Class@.
    @return A new @Class@ inherited from @superclass.

    Creates a new @Class@ by subclassing @superclass and
    using @body_block as its body.
    """

    new(superclass, &body_block)
  }

  def initialize {
    """
    Initializes a @Class@ with @Object@ set as superclass (default superclass).
    """
    initialize: Object
  }

  def initialize: superclass {
    """
    Initializes a @Class@ with a superclass.
    """
    initialize(superclass)
  }

  def define_method: name with: block {
    """
    @name Name of the method to be defined.
    @block A @Block@ that is used as the method's body.

    Defines an instance method on a @Class@ with a given name and
    body.
    """

    match block {
      case Block -> define_method(name message_name, &block)
      case _ -> define_method(name message_name, block)
    }
  }

  def undefine_method: name {
    """
    @name Name of the method to undefine (remove) from a @Class@.

    Undefines an instance method on a Class with a given name.
    """

    remove_method(name message_name)
  }

  def define_class_method: name with: block {
    """
    @name Name of the class method to be defined.
    @block A @Block@ to be used as the class methods body.

    Defines a class method on a @Class@ (a singleton method) with a
    given name and body.
    """

    define_singleton_method: name with: block
  }

  def undefine_class_method: name {
    """
    @name Name of the class method to undefine (remove).

    Undefines a class method on a @Class@ with a given name.
    """

    undefine_singleton_method: name
  }

  def subclass: body_block {
    """
    @body_block A @Block@ that gets used as the body of the @Class@.
    @return A new @Class@ inherited from @self.

    Creates a new @Class@ with @self as superclass and the given body.
    """

    Class superclass: self body: body_block
  }

  def nested_classes {
    """
    @return @Set@ of all nested classes for @self.

    Returns all the nested classes within a @Class@ as an @Array@.
    """

    Set[constants map: |c| { const_get(c) } . select: @{ is_a?: Class }]
  }

  def instance_method: name {
    """
    @name Name of the instance method to return.
    @return The instance @Method@ with the given @name or @nil.

    Returns an instance method for a @Class@ with a given name.
    """

    instance_method(name message_name)
  }

  def has_method?: method_name {
    lookup_method(method_name message_name) nil? not
  }

  def alias_method_rbx: new_method_name for: old_method_name {
    """
    Rbx specific version of alias_method:for: due to bootstrap order
    reasons. Should not be used directly.
    """

    alias_method(new_method_name message_name, old_method_name message_name)
  }

  def alias_method: new_method_name for_ruby: ruby_method_name {
    """
    Creates a method alias for a Ruby method.
    """
    alias_method(new_method_name message_name, ruby_method_name)
  }

  def public: method_names {
    """
    @method_names One or more (@Array@) method names (as a @Symbol@) to be set to public in this @Class@.

    Sets any given method names to public on this @Class@.
    """

    method_names = method_names to_a() map() @{ message_name }
    public(*method_names)
  }

  def private: method_names {
    """
    @method_names One or more (@Array@) method names (as a @Symbol@) to be set to private in this @Class@.

    Sets any given method names to private on this @Class@.
    """

    method_names = method_names to_a() map() @{ message_name }
    private(*method_names)
  }

  def protected: method_names {
    """
    @method_names One or more (@Array@) method names (as a @Symbol@) to be set to protected in this @Class@.

    Sets any given method names to protected on this @Class@.
    """

    method_names = method_names to_a() map() @{ message_name }
    protected(*method_names)
  }

  def instance_methods: include_superclasses? (true) {
    """
    @include_superclasses? Boolean indicating if instance methods of all superclasses should be included (defaults to @true).
    @return @Array@ of all instance method names for this @Class@.
    """

    instance_methods(include_superclasses?)
  }

  def methods: include_superclasses? (true) {
    """
    @include_superclasses? Boolean indicating if methods of all superclasses should be included (defaults to @true).
    @return @Array@ of all class method names for this @Class@.
    """

    methods(include_superclasses?)
  }

  def forwards_unary_ruby_methods {
    """
    Creates ruby_alias methods for any unary ruby methods of a class.
    """

    instance_methods select() |m| {
      m =~(/^[a-z]+/)
    } select() |m| {
      instance_method(m) arity() == 0
    } each() |m| {
      ruby_alias: m
    }
  }

  def class_eval: str_or_block {
    """
    @str_or_block @String@ or @Block@ to be evaluated in the context of this @Class@.

    Evaluates a given @String@ of Fancy code or a @Block@ in the class context of @self.
    Useful for dynamically defining methods on a class etc.

    Example:
          Array class_eval: \"def foo { 'foo println }\"
          [1,2,3] foo  # => prints 'foo
    """

    match str_or_block {
      case Block -> class_eval(&str_or_block)
      case _ -> class_eval: { str_or_block to_s eval }
    }
  }

  def expose_to_ruby: method_name as: ruby_method_name (nil) {
    """
    @method_name Fancy method name to be exposed.
    @ruby_method_name Name of method exposed to Ruby (optional).

    Explicitly exposes a Fancy method to Ruby. If @ruby_method_name is
    passed, use that name explicitly, otherwise uses @method_name.

    Example:
          class Foo {
            def === other {
              # ...
            }

            expose_to_ruby: '===

            # if you don't want to expose it as :=== in Ruby:
            expose_to_ruby: '=== as: 'some_other_name_for_ruby
          }
    """

    match ruby_method_name {
      case nil -> alias_method(method_name, method_name message_name)
      case _ -> alias_method(ruby_method_name, method_name message_name)
    }
  }
}
