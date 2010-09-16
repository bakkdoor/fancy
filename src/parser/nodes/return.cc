#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

#include "return.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      ReturnStatement::ReturnStatement(Expression* return_expr) :
        _return_expr(return_expr)
      {
      }

      FancyObject* ReturnStatement::eval(Scope *scope)
      {
        FancyObject* retval = _return_expr->eval(scope);
        return_value rv;
        rv.return_value = retval;
        rv.enclosing_method = _enclosing_method;
        throw rv;
      }

      string ReturnStatement::to_sexp() const
      {
        return "['return, " + _return_expr->to_sexp() + "]";
      }

    }
  }
}
