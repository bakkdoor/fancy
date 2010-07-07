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
        return retval;
      }

      string ReturnStatement::to_sexp() const
      {
        return "[:return, " + _return_expr->to_sexp() + "]";
      }

    }
  }
}
