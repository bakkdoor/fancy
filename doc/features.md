# A quick overview of Fancy's features #

### Class definitions (including nested classes that work like modules / namespaces) ###

```fancy
    class Person {
      # Person constructor method.
      # @name, @age & @friends instance variables get auto-assigned
      # from the arguments.
      # Also, the friends: parameter is optional (has a default value
      # of [], the empty Array).

      def initialize: @name age: @age friends: @friends ([]) {
      }
    }

    # Nested class:

    class World {
      # Nested class "Agent" in surrounding class "World"
      class Agent {
        # accessible via: World Agent
        # e.g.: World Agent new println
        # ...
      }
      # ...
    }
```

### Instance & class method definitions ###

```fancy
    class Foo {
      def instance_method: an_argument {
        """
        @an_argument Describe an_argument here.
        @return Describe return value here, if any (@nil@ if there's no explicit return value ).

        Method description here:
        This is a docstring and can get retrieved programmatically
        within any Fancy code using this class.
        Use this for documenting your method.
        """
        @an_instance_var = an_argument some_method

      }

      def class_method: another_argument {
        @@a_class_var = another_argument another_method
      }
    }
```

### Literal syntax for: ###
 * Symbols:
   * `'foo`
   * `'foo:bar:`
   * `'baz123!?`
   * `'*`
   * `'==`
 * Single-line Strings:
   * `"Hello, World"`
 * Multi-line Strings (also used for docstrings):

        """
        Hello,
        World
        """

 * Integers:
   * `12312123`
   * `0xFF` (hexadecimal)
   * `0o77` (octal)
   * `0b1010110` (binary)
 * Floats:
   * `121231.12312318948`
 * Arrays:
   * `[1,2,3]`
   * `["foo", "bar", 'baz]`
 * Hashes (HashMaps):
   * `<['foo => "bar", "baz" => 123.123]>`
 * Blocks (closures):
   * `|x y| { x + y }` (2 arguments)
   * `|x, y, z| { x + y + z }` (3 arguments - comma as seperator is optional)
   * `{ "hello, world" println }` (no arguments)
   * `@{ + 2 }` (partial Block, can be used like this: `[1,2,3] map: @{ + 2 }` and is the same as: `[1,2,3] map: |x| { x + 2 }`
 * Ranges:
   * `(1..10)`
   * `(x..x ** x)`
 * Tuples:
   * `(1,2,3)`
   * `(1, "foo", 'bar, [1.123, "hello"])`
 * Regular Expressions:
   * `/^([a-z]+[0-9]*)-([0-9]+)$/`
   * `/^hello, [wW]orld$/`

### Method & Operator calls ###

```fancy
    object a_simple_message      # unary (0-argument) message to object
    object && another_object     # operator (binary) message to object
    object give: "foo" to: "bar" # keyword message to object with arguments "foo" and "bar"
```

### Instance & class variable access ###
 * Instance variables: `@name`, `@age`
 * Class variables: `@@total`, `@@maximum`

### Dynamically scoped variables ###

```fancy
    File open: "/tmp/foo.txt" modes: ['write] with: |f| {
      let: '*stdout* be: f in: {
        "foo" println # writes to /tmp/foo.txt instead of normal STDOUT (console)
      }
    }
    # *stdout* is back to old value here.
```

### Dynamic getter and setter method definitions (similar to Ruby's attr_acessor) ###

```fancy
    class Person {
      # getter methods:
      read_slots: ['name, 'age]

      # setter methods:
      write_slots: ['location, 'friends]

      # getter & setter methods
      read_write_slots: ['location, 'friends, 'money]
    }
```

### Loops ###

```fancy
    { x < y } while_true: {
      x println
      x = x + 1
    }
    # same thing, just more conventional:
    while: { x < y } do: {
      x println
      x = x + 1
    }

    until: { x >= y } do: {
      x println
      x = x + 1
    }

    # endless loop (need to return from it to quit looping):
    loop: {
      "Fancy is cool!" println
    }

    # break from iteration
    10 times: |i| {
      { break i } if: (i == 5) # quit from iteration and returning 5
      # do something else here
    }

    # skip current iteration and move on with next
    10 times: |i| {
      { next } if: (i == 5)
      # do something else here
    }
```

### Support for closures via Blocks ###

```fancy
    x = 0
    10 times: {
      x println
      x = x + x
    }
    x println # x has been modified in the block passed to the times: message

    # call blocks with arguments:
    b = |x y| { x + y println }
    b call: [2, 3]      # prints 5
    b(2,3)              # same as above
```

### Local & non-local returns from Blocks & Methods ###

 * Local returns: `return_local "done!"`, `return_local 123`

   They're used when you explicitly only need to return from the
   current (execution) block.
   E.g. if you want to short-circuit return from a Block passed into a
   collections method (like map:, select: etc.).
   They work like returns from lambda's in Ruby.

 * Non-local returns: `return "done!"`, `return 123`

   Non-local returns are used most of the time and always return from
   the enclosing method in which a Block is called. They work like
   returns in Ruby within Blocks.

### Class-Mixins (including methods of one class into another) ###

```fancy
    class MyClass {
      # include all methods of MyMixinClass into MyClass
      include: MyMixinClass
      # ...
    }
```

### Exception handling (try, catch, finally & retry) ###

```fancy
    try {
      File read: "/etc/passwd" . println
    } catch IOError => e {
      "Got an error: " ++ (e message) println
    } finally {
      # do something important here.
    }

    # retry example:
    x = 0
    try {
      10 / x println
    } ZeroDivisionError => e {
      x = 1 + random: 10    # reset x to be != 0
      retry                 # and run try block again
    } finally {
      "it worked!" println  # this gets run at the end
    }
```

### Simple pattern matching (work-in-progress) ###

```fancy
    def match_it: a_string {
      match a_string {
        case /^hello, (\S+)!$/ -> |_, name| # _ gets bound to matcher object (not used)
          "You greeted: #{name}" println
        case _ -> "No match, sorry." println
      }
    }
```

### Single and multiple assignment. ###

```fancy
    x = "foo"
    x, y = "Hello", "World"
    x, y = y, x # swap x and y

    # splat assignments for any object supporting range access via
    # from:to: message
    a, b, *rest = [1,2,3,4,5,6]   # => a = 1, b = 2, rest = [3,4,5,6]
    *a, *b = [1,2,3]              # => a = [1,2,3], b = [2,3]
```

### Calling, using and extending arbitrary Ruby classes and methods (including C-extensions). ###

```fancy
    require("open3")     # require ruby's open3 library
    require: "fancy_irc" # require fancy's fancy_irc library
    require("activerecord")

    class ActiveRecord Base {
      # let's add a crazy method to ActiveRecord::Base :P
      def crazy_method {
        "Welcome to Fancy's extension capabilities!" println
      }
    }
```

### Standard library ###
* Including:
 * File IO
 * Threads
 * Sockets
 * Fibers
 * => *basically anything that Ruby & Rubinius provide*
 * **Also:**
 * Package management system (similar to Rubygems). Try this: `$ fancy install bakkdoor/fancy_irc`
 * *FDoc*, a json-based documentation page generator. See
   [http://api.fancy-lang.org](http://api.fancy-lang.org) for a FDoc-generated documentation page
   for Fancy's standard library.
 * **and much more...**
