class Stack {
  """
  A simple Stack container class.
  """

  def initialize {
    @arr = []
  }

  def initialize: size {
    @arr = Array new: size
  }

  def push: obj {
    @arr << obj
  }

  def << obj {
    @arr << obj
  }

  def pop {
    @arr remove_at: (self size - 1)
  }

  def top {
    @arr last
  }

  def size {
    @arr size
  }

  def empty? {
    @arr empty?
  }
}
