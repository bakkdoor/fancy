class Conditions {
  class Condition {
    """
    Base Condition class.
    All Conditions should inherit from this.
    """

    def signal! {
      """
      Signals @self to the condition system.
      The first matching dynamically bound condition handler will be called.
      If no condition handler matching @self is found, the default Debugger will be invoked.

      Example:
            class ZeroDivError : Error # Error is a subclass of Condition
            class Fixnum {
              def divide_by: other {
                if: (other == 0) then: {
                  ZeroDivError new raise! # raise ZeroDivError condition
                } else: {
                  self / other
                }
              }
            }
      """

      *condition_manager* handle: self
    }
  }
}

Condition = Conditions Condition
class Error : Condition
Error documentation: "Base class for all error conditions."

class Exception {
  include: Error
}