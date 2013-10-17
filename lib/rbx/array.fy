class Array {
  ruby_aliases: [ '==, '<<, 'pop, 'last, 'shift, 'flatten, 'flatten! ]
  alias_method: 'flatten: for_ruby: 'flatten
  alias_method: 'flatten!: for_ruby: 'flatten!

  forwards_unary_ruby_methods

  def Array new: size with: default {
    """
    @size Initial size of @Array@.
    @default Default value of new @Array@. Inserted @size times.
    @return New @Array@ with @size values of @default in it.

    Creates a new Array with a given size and default-value.
    If @default is a @Block@, call it with each index instead and
    store the return value.

    Example:

          Array new: 3 with: 'hello    # => ['hello, 'hello, 'hello]
          # default can also be a block, taking the current index.
          Array new: 3 with: @{ * 2 }  # => [0, 2, 4]
    """

    match default {
      case Block -> Array new(size, &default)
      case _ -> Array new(size, default)
    }
  }

  def includes?: obj {
    """
    @obj Object to search for in @self.
    @return @true, if @obj is in @self, @false otherwise.

    Indicates, if an Array includes a given value.
    """

    include?(obj)
  }

  def remove_at: index {
    """
    Removes an element at a given index.
    If given an Array of indices, removes all the elements with these indices.
    Returns the deleted object if an index was given, the last deleted object for an Array given.
    """

    if: (index is_a?: Fixnum) then: {
      deleted = at: index
      delete_at(index)
      return deleted
    } else: {
      count = 0
      deleted_values = []
      index each: |idx| {
        deleted_values << (at: (idx - count))
        delete_at(idx - count)
        count = count + 1
      }
      return deleted_values
    }
    nil
  }
  
  # Late-documented in lib/array.fy#L10
  alias_method: 'at: for: 'at
  alias_method: '[]: for_ruby: '[]=
  
  alias_method: 'at:put: for: '[]:
  alias_method('at_put, '[]=)

  def index: item {
    """
    @item Item/Value for which the index is requested within an @Array@.
    @return Index of the value passed in within the @Array@, or @nil, if value not present.

    Returns the index of an item (or nil, if it isn't in the @Array@).
    If @item is a @Block@, it will return the index of an element for which it yields @true.
    """

    match item {
      case Block -> index(&item)
      case _ -> index(item)
    }
  }

  def last: count {
    """
    @count Number of last elements to get from an @Array@.
    @return @Array@ with up to @count size of last elements in @self.

    Returns new Array with last n elements specified.
    """
    last(count)
  }

  def join: join_str {
    """
    @join_str @String@ by which to @join all elements in @self into a new @String@.
    @return Joined @String@ with all elements with @join_str.

    Joins all elements in the Array with a given @String@.

    Example:

          [1,2,3] join: \", \” # => \”1, 2, 3\"
    """

    join(join_str)
  }

  def join {
    """
    @return Elements of @Array@ joined to a @String@.

    Joins all elements with the empty @String@.

    Example:

          [\"hello\", \"world\", \"!\"] join # => \"hello,world!\"
    """

    join: ""
  }

  def unshift: value {
    """
    @value Value to be added at the front of @self.
    @return @self.

    Inserts a value at the front of @self.

    Example:

          a = [1,2,3]
          a unshift: 10
          a # => [10,1,2,3]
    """

    unshift(value)
  }
}
