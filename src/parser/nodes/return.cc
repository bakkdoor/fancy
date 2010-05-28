#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      ReturnStatement::ReturnStatement(Expression_p return_expr) :
        _return_expr(return_expr)
      {
      }

      ReturnStatement::~ReturnStatement()
      {
      }

      EXP_TYPE ReturnStatement::type() const
      {
        return EXP_RETURNSTATEMENT;
      }

      FancyObject* ReturnStatement::eval(Scope *scope)
      {
        FancyObject_p retval = _return_expr->eval(scope);
        return retval;
      }

    }
  }
}
