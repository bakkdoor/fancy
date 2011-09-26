#The Fancy Programming Language

(C) 2010, 2011 Christopher Bertels chris@fancy-lang.org
http://www.fancy-lang.org

[![Build Status](https://secure.travis-ci.org/bakkdoor/fancy.png)](http://travis-ci.org/bakkdoor/fancy)


----------------------------------------------------------------------
Fancy is a dynamic, object-oriented programming language heavily
inspired by Smalltalk, Ruby, Io and Erlang. It supports dynamic code
evaluation (as in Ruby & Smalltalk), class-based mixins, (simple)
pattern matching, runtime introspection & reflection, "monkey
patching" and much more. It runs on Rubinius, the Ruby VM, and thus
has first-class integration with Ruby's core library and any
additional Ruby libraries that run on Rubinius, including most
C-extensions.

It supports concurrency via the actor-model, including first-class
futures and async message send semantics built into the language,
similar to Io.

For a quick feature overview, have a look at `doc/features.md`
There's also a work-in-progress tutorial/book on Fancy here:
https://github.com/fancy-lang/infancy

Fancy's standard library is all written in Fancy (with some minor
exceptions written in Ruby - see `boot/fancy_ext`).
Have a look at the `lib/` directory.

Fancy is still in development, the implementation has evolved from an
interpreter written in C++ to a fully bootstrapped bytecode compiler
for the Rubinius VM (http://www.rubini.us).
You can see the self-hosted compiler implementation in `lib/compiler/`.

If you want to help out, feel free to contact us:
http://github.com/bakkdoor/fancy/wiki/Get-in-touch

For some example code have a look at the `examples/` directory.

There's also lots of test coverage code. Have a look at the tests/
directory for these. The tests are written in FancySpec, a simple
testing library (somewhat similar to Ruby's RSpec). FancySpec's
implementation can be viewed in `lib/fancy_spec.fy`.

##Compiling / Installing from source:
###Dependencies:
- Rubinius.
  You'll need at least version 1.2.1 for Fancy to work as expected.
  See http://rubini.us/releases/1.2.1/ for more information.
  If you want to take advantage of the latest VM improvements, we
  suggest using rvm and installing rbx-head.
  See http://rvm.beginrescueend.com/ for more information.
- Rake.
- GNU Bison ( version 2.4 and higher otherwise you will get a Segmentation fault ).
- GNU Flex.

Given the tools & libraries mentioned above, Fancy _should_ build without problems
on most *nix systems. We successfully have built Fancy on Debian & Ubuntu, OpenSuSE
and Mac OS X 10.5 and 10.6.

###Standard building procedure:
Building Fancy is just that easy:

    $ cd <fancy_source_path>
    $ rake

This should go pretty fast. It actually compiles Fancy's standard
library and compiler several times. Once via the bootstrap compiler
written in Ruby (see `boot/rbx-compiler/`), and then via the self-hosted
compiler (see `lib/compiler/`) itself.

Once the bootstrapping process is done, you can run the hello world example:

    $ ./bin/fancy examples/hello_world.fy

##Some technical information:
As the language is running on the Rubinius VM, Fancy shares the same
runtime with Ruby. All of Fancy is built upon Ruby objects, so for
example when you open the String class in Fancy, it's just Ruby's
String class.

Because of this, and because in Fancy's standard library (lib/*.fy) we
can define methods with the same name as they're defined in Ruby (but
taking no arguments), we have decided not to overwrite the Ruby
methods.
This ensures that all Ruby libraries for example can use Ruby's
Kernel#print or any other method in Ruby's kernel and work seamlessly.

Here's an example:

    class Object {
      def print {
        "Print itself to the Console."
        Console print: self
      }
    }

To meet this goal, the Fancy compiler renames Fancy methods taking no
arguments (like the previous "print" example) to a method named
":print". Using explicit parens syntax will allow you to invoke any
Ruby method.

    someObject print    # Will actually invoke the Fancy ":print" method.
    someObject print()  # With explicit parens invokes the Ruby method.

Ruby method invocation supports passing a block variable to Ruby as a proc.

    class Something {
      def open: block {
        someRubyMethod(arg0, arg1, &block)
      }
    }
    Something new open: |s| { s work }

    # with this syntax, calling ruby's inject is just as easy.
    # This example will print the number 6
    [1, 2, 3] inject(0) |sum, num| { sum + num } println


##What's already working?
  - Class definitions
    (including nested classes that work like modules / namespaces)
  - Instance & class method definitions
  - Default arguments
  - Literal syntax for:
    - Strings, Symbols, Integers, Floats, Arrays, Hashes (HashMaps), Blocks (closures),
      Ranges, Tuples, Regular Expressions
  - Method & Operator calls
  - Instance & class variable access
  - Dynamically scoped variables (dynamic scoping)
  - Dynamic getter and setter method definitions (similar to Ruby's attr_acessor)
  - Loops (including `next` & `break`)
  - Support for closures via Blocks
  - Local & non-local returns from Blocks & Methods
  - File reading and writing
  - Class-Mixins (including methods of one class into another)
  - Exception handling (try, catch, finally & retry)
  - Simple pattern matching (work-in-progress)
  - Calling, using and extending arbitrary Ruby classes and methods
    (including C-extensions), as well as passing blocks and splat
    arguments to Ruby methods.
  - Futures (`future = object @ message`)
  - Async message sends (`object @@ message`)


##How is it implemented?
  - The lexer & parser are built with GNU Flex & GNU Bison.
    And used as a Ruby c-extension from Rubinius.
    The parser simply invokes methods on Fancy::Parser to build the AST.
    See: `lib/parser/ext/parser.y` & `lib/parser/methods.fy`

  - Once the AST is built, we use Rubinius' excellent compiler chain
    to compile it to bytecode.

  - The `bin/fancy` file is simply a Rubinius code loader for `.fy` files.

##Copyright:
Fancy is licensed under the terms of the BSD license. For more
information on licensing issues have a look at the LICENSE file.
