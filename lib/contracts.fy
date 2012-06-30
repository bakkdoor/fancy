class Class {
  class Contracts {
    class InterfaceNotImplementedError : ArgumentError {
      """
      Exception class that gets raised during @Class@ inclusion
      whenever a class doesn't implement another class' required
      interface.
      """

      read_slots: ('methods, 'interface, 'including_class)
      def initialize: @methods interface: @interface including_class: @including_class {
        initialize: \
        "Methods #{@methods inspect} not implemented for interface: #{@interface name} required in class: #{@including_class name}"
      }
    }
  }

  lazy_slot: 'expected_interface_methods value: { [] }
  lazy_slot: 'provided_interface_methods value: { [] }

  def expects_interface_on_inclusion: methods {
    """
    @methods Collection of method signatures to expect on inclusion into another @Class@.

    Declares a required interface (collection of method signatures) an including class has to provide.

    Example:
          class Enumerable {
            expects_interface_on_inclusion: ['each:]
          }
    """

    @expected_interface_methods = methods to_a
  }

  alias_method: 'expects_interface: for: 'expects_interface_on_inclusion:

  def provides_interface: methods {
    """
    @methods Collection of method signatures this class explicitly declares to provide.

    Example:
          class MyCollection {
            # you can skip this if you actually define each: before you include Fancy Enumerable.
            provides_interface: ['each]
            includes: Fancy Enumerable
          }
    """

    provided_interface_methods append: (methods to_a)
  }

  def provides_interface?: methods {
    """
    @methods Collection of method signatures (an interface) to check for.
    @return @true if all methods in @methods are provided by @self, @false otherwise.
    """

    pim = Set new: $ provided_interface_methods map: @{ message_name to_s } + instance_methods
    methods all?: |m| { pim includes?: (m message_name to_s) }
  }

  def missing_methods_for_interface: methods {
    """
    @methods Collection of method signatures to check.
    @return Collection of methods in @methods this class doesn't provide.
    """

    pim = Set new: $ provided_interface_methods map: @{ message_name to_s } + instance_methods
    methods select: |m| { pim includes?: (m message_name to_s) . not }
  }

  def included: class {
    """
    @class @Class@ to be included in @self. Checks possible interface requirements.

    Default include hook. Make sure to call this via `super included: class`.
    """

    class provides_interface?: expected_interface_methods
    unless: (class provides_interface?: expected_interface_methods) do: {
      not_implemented_methods = class missing_methods_for_interface: expected_interface_methods
      if: (not_implemented_methods size > 0) then: {
        Contracts InterfaceNotImplementedError new: not_implemented_methods interface: self including_class: class . raise!
      }
    }
    true
  }
}