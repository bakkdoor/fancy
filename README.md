# The Fancy Programming Language

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

## Related links
* **Website**: http://www.fancy-lang.org
* **Blog**: http://bakkdoor.net
* **Mailinglist**: http://groups.google.com/group/fancy-lang
* **IRC Channel**: irc://irc.freenode.net:6667/fancy
* **IRC Logs**: http://irc.fancy-lang.org
* **API Documentation**: http://api.fancy-lang.org
* **Related Projects**: https://github.com/fancy-lang
* **Twitter**: [@fancy_lang](https://twitter.com/#!/fancy_lang)
* **Tutorial**: https://github.com/fancy-lang/infancy
* **Videos / Screencasts**: http://www.youtube.com/playlist?list=PLF576B1AD1F5DE1FB

## Compiling / Installing from source:
### Dependencies:
- Rubinius.
  You'll need at least version 1.2.4 for Fancy to work as expected.
  See http://rubini.us/releases/1.2.4/ for more information.
  If you want to take advantage of the latest VM improvements, we
  suggest using rvm and installing rbx-head.
  See http://rvm.beginrescueend.com/ for more information.
- Rake.
- GNU Bison ( version 2.4 and higher otherwise you will get a Segmentation fault ).
- GNU Flex.

Given the tools & libraries mentioned above, Fancy _should_ build without problems
on most *nix systems. We successfully have built Fancy on Debian & Ubuntu, OpenSuSE
and Mac OS X 10.5, 10.6 & 10.7.

### Standard building procedure:
Building Fancy is just that easy:

    $ cd <fancy_source_path>
    $ rake

This should go pretty fast. It actually compiles Fancy's standard
library and compiler several times. Once via the bootstrap compiler
written in Ruby (see `boot/rbx-compiler/`), and then via the self-hosted
compiler (see `lib/compiler/`) itself.

Once the bootstrapping process is done, you can run the hello world example:

    $ ./bin/fancy examples/hello_world.fy

## Some technical information:
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

```fancy
class Object {
  def print {
    "Print itself to the Console."
    Console print: self
  }
}
```

To meet this goal, the Fancy compiler renames Fancy methods taking no
arguments (like the previous "print" example) to a method named
":print". Using explicit parens syntax will allow you to invoke any
Ruby method.

```fancy
someObject print    # Will actually invoke the Fancy ":print" method.
someObject print()  # With explicit parens invokes the Ruby method.
```

Ruby method invocation supports passing a block variable to Ruby as a proc.

```fancy
class Something {
  def open: block {
    someRubyMethod(arg0, arg1, &block)
  }
}
Something new open: |s| { s work }

# with this syntax, calling ruby's inject is just as easy.
# This example will print the number 6
[1, 2, 3] inject(0) |sum, num| { sum + num } println
```

## Copyright:
(C) 2010, 2011, 2012, 2013, Christopher Bertels <chris@fancy-lang.org>

Fancy is licensed under the terms of the BSD license. For more
information on licensing issues have a look at the LICENSE file.
