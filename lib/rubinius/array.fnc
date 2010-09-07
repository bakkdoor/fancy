def class Array {

  def new: size {
    "Array constructor method that takes the initial size of the Array."
    # TODO: implement
  }

  def new: size with: default {
    "Create a new Array with a given size and default-value."
    # TODO: implement
  }

  def each: block {
    "Iterate over all elements in Array. Calls a given Block with each element."
    # TODO: implement
  }

  # skipped ==

  # skipped <<

  # skipped clear

  # skipped size

  def at: index {
    "Returns the value at a given index or nil, if index not valid."
    # TODO: implement
  }

  # skipped at

  def append: arr {
    "Appends another Array onto this one."
    # TODO: implement
  }

  def clone {
    "Clones (shallow copy) the Array."
    # TODO: implement
  }

  def remove_at: index {
    "Removes an element at a given index. \
     If given an Array of indices, removes all the elements with these indices."
    # TODO: implement
  }

  # skipped first

  def second {
    "Returns the second element in the Array"
    self at: 1
  }

  def third {
    "Returns the third element in the Array"
    self at: 2
  }

  def fourth {
    "Returns the fourth element in the Array"
    self at: 3
  }

  def indices: item {
     "Returns an Array of all indices of this item."
    # TODO: implement
  }

  # skipped indices

  def from: from to: to {
    "Returns sub-array starting at from: and going to to:"
    # TODO: implement
  }

  def last {
    "Returns the last element in the Array."
    # TODO: implement
  }

  def last: count {
    "Returns new Array with last n elements specified."
    # TODO: implement
  }

  def any?: block {
    "Takes condition-block and returns true if any element meets it."
    # TODO: implement
  }

  def all?: block {
    "Takes condition-block and returns true if all elements meet it."
    # TODO: implement
  }

  # skipped select

  def select_with_index: {
    "Same as select, just gets also called with an additional argument for each element's index value."
    # TODO: implement
  }

  # skipped reject!


















}
