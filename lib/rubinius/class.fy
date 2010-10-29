class Class {
  ruby_alias: 'superclass
  ruby_alias: '===

  def new {
    obj = self allocate()
    obj initialize
    obj
  }

  # calls initialize:, if defined
  def new: arg {
    obj = self allocate()
    obj initialize: arg
    obj
  }

  def Class superclass: superclass body: body_block {
    "Creates a new Class with a given superclass and body."

    new(superclass, &body_block)
  }

  def define_method: name with: block {
    "Defines an instance method on a Class with a given name and body."

    define_method(message_name: name, &block)
  }

  def undefine_method: name {
    "Undefines an instance method on a Class with a given name."

    remove_method(message_name: name)
  }

  def define_class_method: name with: block {
    """
    Defines a class method on a Class (a singleton method) with a
    given name and body.
    """

    define_singleton_method: name with: block
  }

  def undefine_class_method: name {
    "Undefines a class method on a Class with a given name."

    undefine_singleton_method: name
  }

  def subclass: body_block {
    "Creates a new Class with self as superclass and the given body."

    Class superclass: self body: body_block
  }

  def nested_classes {
    "Not Yet Implemented" raise!
  }

  def instance_method: name {
    "Returns an instance method for a Class with a given name."

     self instance_method(message_name: name)
  }
}
