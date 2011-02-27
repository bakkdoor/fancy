class Stack {
  """
  A simple Stack container class.
  """

  def initialize {
    @arr = []
  }

  def initialize: size {
    "Initializes a new Stack with a given size."

    @arr = Array new: size
  }

  def push: obj {
    "Pushes a value onto the Stack."

    @arr << obj
  }

  def << obj {
    "Same as Stack#push:."

    @arr << obj
  }

  def pop {
    "Pops the top-of-stack element from the Stack and returns it."

    @arr remove_at: (size - 1)
  }

  def top {
    "Returns the top-of-stack element."

    @arr last
  }

  def size {
    "Returns the size of the Stack."

    @arr size
  }

  def empty? {
    "Indicates, if the Stack is empty."

    @arr empty?
  }
}
