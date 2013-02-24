class Fancy {
  class Enumerable {
    """
    Mixin-Class with useful methods for collections that implement an @each:@ method.
    """

    expects_interface: 'each:

    def at: index {
      """
      @index @Fixnum@ that is the 0-based index into @self.
      @return Value in @self at 0-based position defined by @index.

      Example:
            \"foo\” at: 2 # => \"o\"
            \"foo\” at: 3 # => nil
      """

      each_with_index: |x i| {
        { return x } if: $ i == index
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

    def rest {
      """
      @return @Array@ of all but the first element in @self.
      """

      drop: 1
    }

    def first: amount {
      """
      @amount Amount of first elements to take from @self.
      @return @Array@ of first @amount elements in @self.

      Example:
            (1,2,3,4) first: 2 # => [1,2]
      """

      i = 0
      take_while: {
        i = i + 1
        i <= amount
      }
    }

    def last: amount {
      """
      @amount Amount of last elements to take from @self.
      @return @Array@ of last @amount elements in @self.

      Example:
            (1,2,3,4) last: 2 # => [3,4]
      """

      start_index = size - amount
      i = 0
      drop_while: {
        i = i + 1
        i <= start_index
      }
    }

    def includes?: item {
      """
      @item Item to check if it's included in @self.
      @return @true, if @item in @self, otherwise @false.

      Indicates, if a collection includes a given element.
      """

      any?: |x| { x == item }
    }

    def each: each_block in_between: between_block {
      """
      Similar to @each:@ but calls an additional @Block@ between
      calling the first @Block@ for each element in self.

      Example:
            result = \"\"
            [1,2,3,4,5] each: |i| {
              result << i
            } in_between: {
              result << \"-\"
            }
            result # => \"1-2-3-4-5\"
      """

      between = { between = between_block }
      each: |x| {
        between call
        each_block call: [x]
      }
    }

    def join: str ("") {
      """
      @str Value (usually a @String@) to be used for the joined @String@.
      @return @String@ containing all elements in @self interspersed with @str.

      Joins a collection with a @String@ between each element, returning a new @String@.

      Example:
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

    def join_by: block {
      """
      @block @Block@ to be called pair-wise to produce a single value.
      @return Result of calling @block pairwise (similar to using @Fancy::Enumerable#reduce:into:@).

      Works similar to @Fancy::Enumerable#inject:into:@ but uses first element as value injected.

      Example:
            (1,2,3) join_by: '+  # => same as: (2,3) inject: 1 into: '+
      """

      first, *rest = self
      rest inject: first into: block
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

    def find: item do: block {
      """
      @item Item to find in @self.
      @block @Block@ to be called with @item if found in @self.

      Calls @block with @item, if found.
      If @item is not in @self, @block is not called.
      """

      if: (find: item) then: block
    }

    def find_with_index: item do: block {
      """
      @item Item to find in @self.
      @block @Block@ to be called with @item and its index in @self.

      Calls @block with @item and its index in @self, if found.
      If @item is not in @self, @block is not called.
      """

      for_every: item with_index_do: |x i| {
        return block call: [x, i]
      }
      nil
    }

    def for_every: item with_index_do: block {
      """
      @item Item to call @block with.
      @block @Block@ to be called with @item and each of its indexes in @self.

      Calls @block with @item and each of its indexes in @self, if @item is in @self.
      """

      each_with_index: |x i| {
        if: (item == x) then: {
          block call: [x, i]
        }
      }
    }

    def for_every: item do: block {
      """
      @item Item to call @block with.
      @block @Block@ to be called with @item for every occurance of @item in @self.

      Calls @block with @item for each occurance of @item in @self.

      Example:
            count = 0
            [1,2,3,2,1] for_every: 1 do: { count = count + 1 }
            # count is now 2
      """

      each: |x| {
        if: (item == x) then: { block call: [x] }
      }
    }

    def last_index_of: item {
      """
      @item Item for which the last index in @self should be found.
      @return Last index of @item in @self, or @nil (if not in @self).

      Returns the last index for @item in @self, or @nil, if @item is not in @self.
      """

      last_idx = nil
      for_every: item with_index_do: |_ i| { last_idx = i }
      last_idx
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

    def flat_map: block {
      """
      Similar to @Fancy::Enumerable#map:@ but returns the result @Array@ flattened.
      """

      map: block . tap: @{ flatten! }
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

    def select_with_index: condition {
      """
      @condition A @Block@ that is used as a filter on all elements in @self.
      @return An @Array@ containing all elements and their indices in @self that yield @true when called with @condition.

      Returns a new @Array@ with all elements and their indices that meet the given
      condition block. @condition is called with each element and its index in @self.
      """

      tmp = []
      each_with_index: |obj idx| {
        if: (condition call: [obj, idx]) then: {
          tmp << [obj, idx]
        }
      }
      tmp
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
      @return @Array@ of first @amount elements in @self.

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

    def drop_last: amount (1) {
      """
      @amount Amount of elements to drop from the end.
      @return New @Array@ without last @amount elements.

      Example:
            [1,2,3,4] drop_last: 2  # => [1,2]
      """

      first: (size - amount)
    }

    def reduce: block init_val: init_val {
      """
      Calculates a value based on a given block to be called on an accumulator
      value and an initial value.

      Example:
            [1,2,3] reduce: |sum val| { sum + val } init_val: 0 # => 6
      """

      acc = init_val
      each: |x| {
        acc = block call: [acc, x]
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

    def unique {
      """
      @return @Array@ of all unique elements in @self.

      Returns a new Array with all unique values (double entries are skipped).

      Example:
            [1,2,1,2,3] unique # => [1,2,3]
      """

      unique_vals = []
      each: |x| {
        unless: (unique_vals includes?: x) do: {
          unique_vals << x
        }
      }
      unique_vals
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

    def superior_by: comparison_block taking: selection_block (@{ identity }) {
      """
      @comparison_block @Block@ to be used for comparison.
      @selection_block @Block@ to be used for selecting the values to be used for comparison by @comparison_block.
      @return Superior element in @self in terms of @comparison_block.

      Returns the superior element in the @Fancy::Enumerable@ that has met
      the given comparison block with all other elements,
      applied to whatever @selection_block returns for each element.
      @selection_block defaults to @identity.

      Examples:
            [1,2,5,3,4] superior_by: '> # => 5
            [1,2,5,3,4] superior_by: '< # => 1
            [[1,2], [2,3,4], [], [1]] superior_by: '> taking: 'size # => [2,3,4]
            [[1,2], [2,3,4], [-1]] superior_by: '< taking: 'first # => [-1]
      """

      retval     = first
      retval_cmp = selection_block call: [retval]

      rest each: |p| {
        cmp = selection_block call: [p]
        if: (comparison_block call: [cmp, retval_cmp]) then: {
          retval     = p
          retval_cmp = cmp
        }
      }
      retval
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

    def min_max {
      """
      @return @Tuple@ of min and max value in @self.

      If @self is empty, returns (nil, nil).

      Example:
            (1,2,3,4) min_max # => (1, 3)
      """

      min_max_by: @{ identity }
    }

    def min_max_by: block {
      """
      @block @Block@ to calculate the min and max value by.
      @return @Tuple@ of min and max value based on @block in @self.

      Calls @block with each element in @self to determine min and max values.
      If @self is empty, returns (nil, nil).

      Example:
            (\"a\", \”bc\", \”def\") min_max_by: 'size # => (1, 3)
      """

      min, max = nil, nil
      min_val, max_val = nil, nil
      each: |x| {
        val = block call: [x]
        { min = val; min_val = x } unless: min
        { min = val; min_val = x } if: (val < min)
        { max = val; max_val = x } unless: max
        { max = val; max_val = x } if: (val > max)
      }
      (min_val, max_val)
    }

    def sum {
      """
      Calculates the sum of all the elements in the @Enumerable
      (assuming them to be @Number@s (implementing '+' & '*')).
      """

      inject: 0 into: '+
    }

    def product {
      """
      Calculates the product of all the elements in the @Enumerable
      (assuming them to be @Number@s (implementing @+ & @*)).
      """

      inject: 1 into: '*
    }

    def average {
      """
      @return Average value in @self (expecting @Number@s or Objects implementing @+ and @*).
      """

      { return 0 } if: empty?
      sum to_f / size
    }

    def partition_by: block {
      """
      @block @Block@ that gets used to decide when to partition elements in @self.
      @return @Array@ of @Array@s, partitioned by equal return values of calling @block with each element

      Example:
            (0..10) partition_by: @{ < 3 }  # => [[0, 1, 2], [3, 4, 5, 6, 7, 8, 9, 10]]
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

    def chunk_by: block {
      """
      @block @Block@ to chunk @self by.
      @return @Array@ of chunks, each including the return value of calling @block with elements in the chunk, as well as the elements themselves (within another @Array@).

      Similar to @Fancy::Enumerable#partition_by:@ but includes the value of
      calling @block with an element within the chunk.

      Example:
            [1,3,4,5,6,8,10] chunk_by: 'odd?
            # => [[true, [1,3]], [false, [4]], [true, [5]], [false, [6,8,10]]]
      """

      { return [] } if: empty?

      chunks = []
      curr_chunk = []
      initial = first
      last_val = block call: [initial]
      curr_chunk << initial

      rest each: |x| {
        val = block call: [x]
        if: (val != last_val) then: {
          chunks << [last_val, curr_chunk]
          curr_chunk = []
        }
        curr_chunk << x
        last_val = val
      }
      { chunks << [last_val, curr_chunk] } unless: $ curr_chunk empty?
      chunks
    }

    def random {
      """
      @return Random element in @self.
      """

      at: $ size random
    }

    def sort: comparison_block {
      """
      @comparison_block @Block@ taking 2 arguments used to compare elements in a collection.
      @return Sorted @Array@ of elements in @self.

      Sorts a collection by a given comparison block.
      """

      sort(&comparison_block)
    }

    def sort_by: block {
      """
      @block @Block@ taking 1 argument used to extract a value to use for comparison.
      @return Sorted @Array@ of elements in @self based on @block.

      Sorts a collection by calling a @Block@ with every element
      and using the return values for comparison.

      Example:
            [\"abc\", \"abcd\", \"ab\", \"a\", \"\"] sort_by: @{ size }
            # => [\"\", \"a\", \"ab\", \"abc\", \"abcd\"]
      """

      sort_by() |x| {
        block call: [x]
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

      { return groups } if: (size <= 0)

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

    def group_by: block {
      """
      @block @Block@ used to group elements in @self by.
      @return @Hash@ with elements in @self grouped by return value of calling @block with them.

      Returns the elements grouped by @block in a @Hash@ (the keys being the
      value of calling @block with the elements).

      Example:
            ('foo, 1, 2, 'bar) group_by: @{ class }
            # => <[Symbol => ['foo, 'bar], Fixnum => [1,2]]>
      """

      h = <[]>
      each: |x| {
        group = h at: (block call: [x]) else_put: { [] }
        group << x
      }
      h
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

    def count: block {
      """
      @block Predicate @Block@ called with each element.
      @return @Fixnum@ that is the amount of elements in @self for which @block yields @true.

      Example:
            (0..10) count: @{ even? }                   # => 6 (even numbers are: 0,2,4,6,8,10)
            [1,2,3] count: @{ odd? }                    # => 2
            [1,2, \"foo\"] count: @{ class == String }  # => 1
      """

      count = 0
      each: |x| {
        { count = count + 1 } if: $ block call: [x]
      }
      count
    }

    def to_s {
      """
      @return @String@ concatenation of elements in @self.

      Example:
            (1,2,3) to_s # => \"123\"
            [1,2,3] to_s # => \"123\"
            \"foo\" to_s # => \"foo\"
      """

      join
    }

    def sorted? {
      """
      @return @true if @self is sorted, @false otherwise.

      Example:
            (1,2,3) sorted? # => true
            (2,1,3) sorted? # => false
            \"abc\" sorted? # => true
            \"bac\" sorted? # => false
      """

      last = nil
      each: |x| {
        if: last then: {
          { return false } unless: $ last <= x
        }
        last = x
      }
      true
    }

    def split_at: index {
      """
      @index Index at which @self should be split.
      @return @Array@ of 2 @Array@s of elements in self splitted at @index.

      Example:
            [1,2,3,4,5] split_at: 2 # => [[1,2], [3,4,5]]
      """

      [take: index, drop: index]
    }

    def split_with: predicate_block {
      """
      @predicate_block @Block@ to be used as a predicate on where to split in @self.
      @return @Array@ of 2 @Array@s of elements split based on @predicate_block.

      Example:
            [1,2,3,4,5] split_with: @{ < 3 } # => [[1, 2], [3, 4, 5]]
      """

      [take_while: predicate_block, drop_while: predicate_block]
    }

    def grep: pattern {
      """
      @pattern Pattern to be filtered by (via @Object#===@)
      @return Elements in @self for which @pattern matches.

      Example:
            \"hello world\" grep: /[a-h]/                 # => [\"h\", \"e\", \"d\"]
            [\"hello\", \"world\", 1, 2, 3] grep: String  # => [\"hello\", \"world\"]
      """

      select: |x| { pattern === x }
    }

    def grep: pattern taking: block {
      """
      @pattern Pattern to be filtered by (via @Object#===@)
      @block @Block@ to be called with each element for which @pattern matches.
      @return Return values of elements in @self called with @block for which @pattern matches.

      Example:
            \"hello world\" grep: /[a-h]/ taking: @{ upcase }             # => [\"H\", \"E\", \"D\"]
            [\"hello\", \"world\", 1, 2, 3] grep: String taking: 'upcase  # => [\"HELLO\", \"WORLD\"]
      """

      result = []
      each: |x| {
        match x {
          case pattern -> result << (block call: [x])
        }
      }
      result
    }

    def one?: block {
      """
      @block @Block@ to be used to check for a condition expected only once in @self.
      @return @true if @block yields @true only once for all elements in @self.

      Example:
            (0,1,2) one?: 'odd?  # => true
            (0,1,2) one?: 'even? # => false
      """

      got_one? = false
      each: |x| {
        if: (block call: [x]) then: {
          { return false } if: got_one?
          got_one? = true
        }
      }
      return got_one?
    }

    def none?: block {
      """
      @block @Block@ to be used to check for a condition expected not once in @self.
      @return @true if none of the elements in @self called with @block yield @true.

      Example:
            (0,2,4) none?: 'odd?   # => true
            (0,2,5) none?: 'odd? # => false
      """

      any?: block . not
    }
  }
}