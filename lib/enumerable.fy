class Fancy {
  class Enumerable {
    """
    Mixin-Class with useful methods for collections that implement an @each:@ method.
    """

    def at: index {
      """
      @index @Fixnum@ that is the 0-based index into @self.
      @return Value in @self at 0-based position defined by @index.

      Example:
            \"foo\” at: 2 # => \"o\"
            \"foo\” at: 3 # => nil
      """

      i = 0
      each: |x| {
        { return x } if: $ i == index
        i = i + 1
      }
      return nil
    }

    def each_with_index: block {
      """
      @block @Block@ to be called with each element and its index in the @self.
      @return @self

      Iterate over all elements in @self.
      Calls a given @Block@ with each element and its index.
      """

      i = 0
      each: |x| {
        block call: [x, i]
        i = i + 1
      }
    }

    def first {
      """
      @return The first element in the @Fancy::Enumerable@.
      """
      at: 0
    }

    def second {
      """
      @return The second element in the @Fancy::Enumerable@.
      """
      at: 1
    }

    def third {
      """
      @return The third element in the @Fancy::Enumerable@.
      """
      at: 2
    }

    def fourth {
      """
      @return The fourth element in the @Fancy::Enumerable@.
      """
      at: 3
    }

    def last {
      """
      @return Last element in @self or @nil, if empty.

      Returns the last element in a @Fancy::Enumerable@.
      """

      item = nil
      each: |x| {
        item = x
      }
      item
    }

    def includes?: item {
      """
      @item Item to check if it's included in @self.
      @return @true, if @item in @self, otherwise @false.

      Indicates, if a collection includes a given element.
      """

      any?: @{ == item }
    }

    def each: each_block in_between: between_block {
      """
      Similar to @each:@ but calls an additional @Block@ between
      calling the first @Block@ for each element in self.
      """

      between = { between = between_block }
      each: |x| {
        between call
        each_block call: [x]
      }
    }

    def join: str {
      """
      @str Value (usually a @String@) to be used for the joined @String@.
      @return @String@ containing all elements in @self interspersed with @str.

      Joins a collection with a @String@ between each element, returning a new @String@.

            \"hello, world\" join: \"-\" # => \"h-e-l-l-o-,- -w-o-r-l-d\"
      """

      s = ""
      each: |c| {
        s << c
      } in_between: {
        s << str
      }
      s
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
      false
    }

    def all?: condition {
      """
      @block Predicate @Block@ to be called for each element until it returns @false for any one of them.
      @return @true if all elements in @self yield @true for @block, @false otherwise.

      Takes condition-block and returns @true if all elements meet it.
      """

      each: |x| {
        unless: (condition call: [x]) do: {
          return false
        }
      }
      true
    }

    def find: item {
      """
      @item Item to be found in @self.
      @return The first element that is equal to @item or @nil, if none found.

      Returns @nil, if @item (or anything that returns @true when comparing to @item) isn't found.
      Otherwise returns that element that is equal to @item.
      """

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
        if: (block call: [x]) then: {
          return x
        }
      }
      nil
    }

    def map: block {
      """
      @block A @Block@ that gets called with each element in @self.
      @return An @Array@ containing all values of calling @block with each element in @self.

      Returns a new @Array@ with the results of calling a given block for every element.
      """

      coll = []
      each: |x| {
        coll << (block call: [x])
      }
      coll
    }

    def map_with_index: block {
      """
      @block A @Block@ that gets called with each element and its index in @self.
      @return An @Array@ containing all values of calling @block with each element and its index in @self.

      Returns a new @Array@ with the results of calling a given block for every element and its index.
      """

      coll = []
      each_with_index: |x i| {
        coll << (block call: [x, i])
      }
      coll
    }

    def map_chained: blocks {
      """
      @blocks Collection of @Block@s to be called sequentially for every element in @self.
      @return Collection of all values in @self successively called with all blocks in @blocks.

      Example:
            (1,2,3) map_chained: (@{ + 1 }, 'to_s, @{ * 2 })
            # => [\"22\", \"33\", \"44\"]
      """

      map: |v| {
        blocks inject: v into: |acc b| {
          b call: [acc]
        }
      }
    }

    def select: condition {
      """
      @condition A @Block@ that is used as a filter on all elements in @self.
      @return An @Array@ containing all elements in @self that yield @true when called with @condition.

      Returns a new @Array@ with all elements that meet the given condition block.
      """

      coll = []
      each: |x| {
        { coll << x } if: $ condition call: [x]
      }
      coll
    }

    def reject: condition {
      """
      Similar to @select:@ but inverse.
      Returns a new @Array@ with all elements that don't meet the given condition block.
      """

      coll = []
      each: |x| {
        { coll << x } unless: $ condition call: [x]
      }
      coll
    }

    def take_while: condition {
      """
      @condition A @Block@ that is used as a condition for filtering.
      @return An @Array@ of all elements from the beginning until @condition yields @false.

      Returns a new @Array@ by taking elements from the beginning
      as long as they meet the given condition block.

      Example:
            [1,2,3,4,5] take_while: |x| { x < 4 } # => [1,2,3]
      """

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
      """
      Similar to @take_while:@ but inverse.
      Returns a new @Array@ by skipping elements from the beginning
      as long as they meet the given condition block.

      Example:
            [1,2,3,4,5] drop_while: |x| { x < 4 } # => [4,5]
      """

      coll = []
      drop = nil
      first_check = true
      each: |x| {
        if: (drop or: first_check) then: {
          drop = condition call: [x]
          first_check = nil
          # check, if we actually have to insert this one:
          unless: drop do: {
            coll << x
          }
        } else: {
          coll << x
        }
      }
      coll
    }

    def take: amount {
      """
      @amount Amount of elements to take from @self.
      @return First @amount elements of @self in an @Array@.

      Example:
            [1,2,3,4] take: 2 # => [1,2]
      """

      i = 0
      take_while: {
        i = i + 1
        i <= amount
      }
    }

    def drop: amount {
      """
      @amount Amount of elements to skip in @self.
      @return An @Array@ of all but the first @amount elements in @self.

      Example:
            [1,2,3,4,5] drop: 2 # => [3,4,5]
      """

      i = 0
      drop_while: {
        i = i + 1
        i <= amount
      }
    }

    alias_method: 'skip: for: 'drop:

    def reduce: block init_val: init_val {
      """
      Calculates a value based on a given block to be called on an accumulator
      value and an initial value.

      Example:
            [1,2,3] reduce: |sum val| { sum + val } init_val: 0 # => 6
      """

      acc = init_val
      each: |x| {
        acc = (block call: [acc, x])
      }
      acc
    }

    def inject: val into: block {
      """
      Same as reduce:init_val: but taking the initial value as first
      and the reducing block as second parameter.

      Example:
            [1,2,3] inject: 0 into: |sum val| { sum + val } # => 6
      """

      reduce: block init_val: val
    }

    def uniq {
      """
      @return @Array@ of all unique elements in @self.

      Returns a new Array with all unique values (double entries are skipped).

      Example:
            [1,2,1,2,3] uniq # => [1,2,3]
      """

      uniq_vals = []
      each: |x| {
        unless: (uniq_vals includes?: x) do: {
          uniq_vals << x
        }
      }
      uniq_vals
    }

    def size {
      """
      @return Amount of elements in @self.

      Returns the size of an Enumerable.
      """

      i = 0
      each: {
        i = i + 1
      }
      i
    }

    def empty? {
      """
      @return @true, if size of @self is 0, @false otherwise.

      Indicates, if the Enumerable is empty (has no elements).
      """

      size == 0
    }

    def compact {
      """
      @return @Array@ with all non-nil elements in @self.

      Returns a new @Array@ with all values removed that are @nil ( return @true on @nil? ).

      Example:
            [1,2,nil,3,nil] compact # => [1,2,3]
      """

      reject: @{ nil? }
    }

    def superior_by: comparison_block taking: selection_block ('identity) {
      """
      @comparison_block @Block@ to be used for comparison.
      @selection_block @Block@ to be used for selecting the values to be used for comparison by @comparison_bock.
      @return Superior element in @self in terms of @comparison_block.

      Returns the superior element in the @Enumerable that has met
      the given comparison block with all other elements,
      applied to whatever @selection_block returns for each element.
      @selection_block defaults to @identity.

      Examples:
            [1,2,5,3,4] superior_by: '> # => 5
            [1,2,5,3,4] superior_by: '< # => 1
            [[1,2], [2,3,4], [], [1]] superior_by: '> taking: 'size # => [2,3,4]
            [[1,2], [2,3,4], [-1]] superior_by: '< taking: 'first # => [-1]
      """


      pairs = self map: |val| {
        (val, selection_block call: [val])
      }

      retval = pairs first
      pairs each: |p| {
        if: (comparison_block call: [p second, retval second]) then: {
          retval = p
        }
      }
      retval first
    }

    def max {
      """
      @return Maximum value in @self.

      Returns the maximum value in the Enumerable (via the '>' comparison message).
      """

      superior_by: '>
    }

    def min {
      """
      @return Minimum value in @self.

      Returns the minimum value in the Enumerable (via the '<' comparison message).
      """

      superior_by: '<
    }

    def sum {
      """
      Calculates the sum of all the elements in the @Enumerable
      (assuming them to be @Number@s (implementing '+' & '*')).
      """

      reduce: '+ init_val: 0
    }

    def product {
      """
      Calculates the product of all the elements in the @Enumerable
      (assuming them to be @Number@s (implementing @+ & @*)).
      """

      reduce: '* init_val: 1
    }

    def average {
      """
      @return Average value in @self (expecting @Number@s or Objects implementing @+ and @*).
      """

      { return 0 } if: (size == 0)
      sum to_f / size
    }

    def partition_by: block {
      """
      @block @Block@ that gets used to decide when to partition elements in @self.
      @return @Array@ of @Array@s, partitioned by equal return values of calling @block with each element

      Example:
            0 upto: 10 . partition_by: |x| { x < 3 }  # => [[0, 1, 2], [3, 4, 5, 6, 7, 8, 9, 10]]
      """
      last = block call: [first]
      coll = []
      tmp_coll = []
      each: |x| {
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

    def random {
      """
      @return Random element in @self.
      """

      at: $ size random
    }

    def sort_by: block {
      """
      @block @Block@ taking 2 arguments used to compare elements in a collection.
      @return Sorted @Array@ of elements in @self.

      Sorts a collection by a given comparison block.
      """

      if: (block is_a?: Symbol) then: {
        sort() |a b| {
          a receive_message: block . <=> (b receive_message: block)
        }
      } else: {
        sort(&block)
      }
    }

    def in_groups_of: size {
      """
      @size Maximum size of each group.
      @return @Array@ of @Array@s with a max size of @size (grouped).

      Example usage:
            [1,2,3,4,5] in_groups_of: 3 # => [[1,2,3],[4,5]]
      """

      groups = []
      tmp = []
      enum = to_enum

      loop: {
        size times: {
          tmp << (enum next)
        }

        if: (enum ended?) then: {
          { groups << tmp } unless: $ tmp empty?
          break
        }

        groups << tmp
        tmp = []
      }

      groups
    }

    def reverse {
      """
      @return @self in reverse order.

      Returns @self in reverse order.
      This only makes sense for collections that have an ordering.
      In either case, it simply converts @self to an @Array@ and returns it in reversed order.
      """

      self to_a reverse
    }

    def to_hash: block {
      """
      @block @Block@ to be called to get the key for each element in @self.
      @return @Hash@ of key/value pairs based on values in @self.

      Example:
              [\"foo\", \”hello\", \"ok\", \"\"] to_hash: @{ size }
              # => <[3 => \"foo\", 5 => \"hello\", 2 => \"ok\", 0 => \"\"]>
      """


      inject: <[]> into: |h val| {
        key = block call: [val]
        h[key]: val
        h
      }
    }

    def reverse_each: block {
      """
      @block @Block@ to be called for each element in reverse order.
      @return @self

      Runs @block for each element on reversed version of self.
      If @self is not a sorted collection, no guarantees about the reverse order can be given.
      """

      reverse each: block
    }
  }
}