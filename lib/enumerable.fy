class FancyEnumerable {
  """
  Mixin-Class with useful methods for collections that implement an @each:@ method.
  """

  def includes?: item {
    """
    @item Item to check if it's included in @self.
    @return @true, if @item in @self, otherwise @false.

    Indicates, if a collection includes a given element.
    """
    any?: |x| { item == x }
  }

  def each: each_block in_between: between_block {
    """
    Similar to @each:@ but calls an additional @Block@ between
    calling the first @Block@ for each element in self.
    """

    count = 0
    size = self size
    each: |x| {
      each_block call: [x]
      unless: (count == (size - 1)) do: {
        between_block call
      }
      count = count + 1
    }
  }

  def any?: condition {
    """
    @condition @Block@ (or @Callable) that is used to check if any element in @self yields true for it.
    @return @true, if @condition yields @true for any element, @false otherwise.

    Indicates, if any element meets the condition.
    """

    each: |x| {
      if: (condition call: [x]) then: {
        return true
      }
    }
    nil
  }

  def all?: condition {
    """
    Similar to @FancyEnumerable#any?:@ just checking for all elements.
    Indicates, if all elements meet the condition.
    """

    each: |x| {
      unless: (condition call: [x]) do: {
        return false
      }
    }
    true
  }

  def find: item {
    "Returns @nil, if the given object isn't found, or the object, if it is found."

    if: (item is_a?: Block) then: {
      find_by: item
    } else: {
      each: |x| {
        if: (item == x) then: {
          return x
        }
      }
      nil
    }
  }

  def find_by: block {
    """
    Similar to @find:@ but takes a block that is called for each element to find it.
    """

    each: |x| {
      block call: [x] . if_do: |item| {
        return item
      }
    }
    nil
  }

  def map: block {
    "Returns a new @Array@ with the results of calling a given block for every element"

    coll = []
    each: |x| {
      coll << (block call: [x])
    }
    coll
  }

  def select: condition {
    "Returns a new @Array@ with all elements that meet the given condition block."

    coll = []
    each: |x| {
      { coll << x } if: $ condition call: [x]
    }
    coll
  }

  def reject: condition {
    "Returns a new @Array@ with all elements that don't meet the given condition block."

    coll = []
    each: |x| {
      { coll << x } unless: $ condition call: [x]
    }
    coll
  }

  def take_while: condition {
    "Returns a new @Array@ by taking elements from the beginning as long as they meet the given condition block."
    coll = []
    each: |x| {
      if: (condition call: [x]) then: {
        coll << x
      } else: {
        return coll
      }
    }
    coll
  }

  def drop_while: condition {
    "Returns a new @Array@ by skipping elements from the beginning as long as they meet the given condition block."

    coll = []
    drop = nil
    first_check = true
    each: |x| {
      if: (drop or: first_check) then: {
        drop = condition call: [x]
        first_check = nil
        # check, if we actually have to insert his one:
        unless: drop do: {
          coll << x
        }
      } else: {
        coll << x
      }
    }
    coll
  }

  def reduce: block init_val: init_val {
    "Calculates a value based on a given block to be called on an accumulator value and an initial value."

    acc = init_val
    each: |x| {
      acc = (block call: [acc, x])
    }
    acc
  }

  def uniq {
    "Returns a new Array with all unique values (double entries are skipped)."

    uniq_vals = []
    each: |x| {
      unless: (uniq_vals includes?: x) do: {
        uniq_vals << x
      }
    }
    uniq_vals
  }

  def size {
    "Returns the size of an Enumerable."

    i = 0
    each: |x| {
      i = i + 1
    }
    i
  }

  def empty? {
    "Indicates, if the Enumerable is empty (has no elements)."
    self size == 0
  }

  def first {
    self each: |x| {
      return x
    }
  }

  def last {
    "Returns the last element in an Enumerable."

    item = nil
    each: |x| {
      item = x
    }
    item
  }

  def compact {
    "Returns a new @Array@ with all values removed that are @nil ( return @true on @nil? )."

    reject: |x| { x nil? }
  }

  def superior_by: comparison_block {
    "Returns the superiour element in the @Enumerable that has met the given comparison block with all other elements."

    retval = self first
    each: |x| {
      if: (comparison_block call: [x, retval]) then: {
        retval = x
      }
    }
    retval
  }

  def max {
    "Returns the maximum value in the Enumerable (via the '>' comparison message)."
    superior_by: '>
  }

  def min {
    "Returns the minimum value in the Enumerable (via the '<' comparison message)."
    superior_by: '<
  }

  def partition_by: block {
    last = block call: [self first]
    coll = []
    tmp_coll = []
    self each: |x| {
      tmp = block call: [x]
      if: (tmp != last) then: {
        coll << tmp_coll
        tmp_coll = [x]
      } else: {
        tmp_coll << x
      }
      last = tmp
    }
    coll << tmp_coll
    coll
  }
}
