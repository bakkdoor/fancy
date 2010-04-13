#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      OperatorDefExpr::OperatorDefExpr(Identifier_p op_name, Method_p method) :
        _op_name(op_name),
        _method(method)
      {
      }

      OBJ_TYPE OperatorDefExpr::type() const
      {
        return OBJ_OPERATORDEFEXPR;
      }

      FancyObject_p OperatorDefExpr::eval(Scope *scope)
      {
        scope->current_class()->def_method(_op_name, this->_method);
        return nil;
      }

    }
  }
}
