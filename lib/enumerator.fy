class Fancy {
  class Enumerator {
    def initialize: @collection {
      """
      @collection Collection to iterate over.

      Initializes a new Enumerator with a given @collection,
      using #each: for iteration.
      """

      @iterator = 'each:
      rewind
    }

    def initialize: @collection with: @iterator {
      """
      @collection Collection to iterate over.
      @iterator Selector to use to iterate over @collection.

      Initializes a new Enumerator with a given @collection
      and @iterator selector to be used for iteration.
      """

      rewind
    }

    def next {
      """
      @return Next element in the collection this enumerator is attached to.

      Returns the next element in the collection this enumerator is attached to.
      It will move the internal position forward (compared to e.g. #peek, which doesn't).

      Example:
            a = [1,2,3]
            e = a to_enum
            e next # => 1
            e next # => 2
            e next # => 3
            e next # => raises Fancy StopIteration
      """

      if: @peeked then: {
        @peeked = false
        @peek
      } else: {
        result = @fiber resume
        if: (@fiber alive?) then: {
          return result
        } else: {
          (Fancy StopIteration new: result) raise!
        }
      }
    }

    def ended? {
      """
      @return @true if the enumerator has ended (no more values left), @false otherwise.

      Indicates if an enumerator has ended (no more values left).
      """

      @fiber alive? not
    }

    def peek {
      """
      Returns the next object in the Enumerator, but doesn't move the
      internal position forward.
      When the position reaches the end, a Fancy StopIteration exception is
      raised.

      Example:
            a = [1,2,3]
            e = a to_enum
            e next p #=> 1
            e peek p #=> 2
            e peek p #=> 2
            e peek p #=> 2
            e next p #=> 2
            e next p #=> 3
            e next p #=> raises Fancy StopIteration
      """

      unless: @peeked do: {
        @peeked = true
        @peek = @fiber resume
        if: (@fiber alive?) then: {
          return @peek
        } else: {
          (Fancy StopIteration new: result) raise!
        }
      }

      return @peek
    }

    def rewind {
      """
      Resets the enumerator to start from the collection's beginning.
      """

      @peeked = false
      @peek = nil

      @fiber = Fiber new: {
        param = |element| { yield: element }
        @collection receive_message: @iterator with_params: [param]
      }
    }

    def with: object each: block {
      """
      @object Object to pass along to @block with each element in the collection.
      @block A @Block@ to be called with each element in the collection and @object.

      Similar to #each: but also passing in a given @object to each invocation of @block.
      """

      each: |element| {
        block call: [element, object]
      }

      return object
    }

    def each: block {
      """
      @block @Block@ to be called with each element in the collection (iteration).

      Calls a given @Block@ with each element in the collection this enumerator is attached to.
      Used for iterating over the collection using this enumerator.
      """

      loop: {
        try {
          block call: [next]
        } catch Fancy StopIteration {
          return self
        }
      }
    }

    def chunk: block {
      Generator new: |inner_block| {
        enums = []
        last = nil
        previous = nil
        stack = []

        each: |element| {
          result = (block call: [element]) not not
          if: (previous == result) then: {
            stack << element
          } else: {
            previous if_nil: {
              # wait one gap to call
            } else: {
              inner_block call: [[previous, stack]]
            }
            previous = result
            stack = [element]
            last = [result, stack]
            enums << last
          }
        }

        self
      } . to_enum
    }

    class Generator {
      def initialize: @block

      def each: block {
        @block call: [block]
      }
    }

    def to_a {
      output = []
      each: |element| { output << element }
      output
    }
  }
}