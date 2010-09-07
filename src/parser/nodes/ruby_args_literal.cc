#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

#include "ruby_args_literal.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      RubyArgsLiteral::RubyArgsLiteral(Expression* array_lit)
      {
        if(ArrayLiteral* al = dynamic_cast<ArrayLiteral*>(array_lit)) {
          _array_lit = al;
        } else {
          throw "RubyArgsLiteral: No ArrayLiteral given! Aborting.";
        }
      }

      FancyObject* RubyArgsLiteral::eval(Scope *scope)
      {
        return _array_lit->eval(scope);
      }

      string RubyArgsLiteral::to_sexp() const
      {
        return "['rb_args_lit, " + _array_lit->to_sexp() + "]";
      }

    }
  }
}
