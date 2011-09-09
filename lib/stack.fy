class Stack {
  """
  A simple Stack container class.
  """

  def initialize {
    """
    Initializes a new Stack.
    """

    @arr = []
  }

  def initialize: size {
    """
    @size Initial size of the new Stack.

    Initializes a new Stack with a given size.
    """

    @arr = Array new: size
  }

  def push: obj {
    """
    @obj Object to be pushed onto @self.

    Pushes a value onto the Stack.
    """

    @arr << obj
  }

  alias_method: '<< for: 'push:

  def pop {
    """
    @return Top-of-stack element.

    Pops the top-of-stack element from the Stack and returns it.
    """

    @arr remove_at: (size - 1)
  }

  def top {
    """
    @return The top-of-stack element.
    """

    @arr last
  }

  def size {
    """
    @return Size of the Stack.
    """

    @arr size
  }

  def empty? {
    """
    @return @true if empty, otherwise @false.

    Indicates, if the Stack is empty.
    """

    @arr empty?
  }

  def each: block {
    """
    @block @Block@ to be called with each element in @self.
    @return @self.

    Calls a given @Block@ with each element in @self, starting with the top of stack element.
    """

    @arr reverse_each: block
  }
}
