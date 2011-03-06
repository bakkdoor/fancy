require("fiber")

Fiber = Rubinius Fiber

class Fiber {
   metaclass ruby_alias: 'yield
   ruby_alias: 'resume
   ruby_alias: 'alive?

   def self new: block {
     new(&block)
   }

   def Fiber yield: vals {
     yield(*vals)
   }

   def resume: vals {
     resume(*vals)
   }
}