#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      OperatorDefExpr::OperatorDefExpr(Identifier_p op_name, Method_p method) :
        _op_name(op_name),
        _method(method)
      {
      }

      EXP_TYPE OperatorDefExpr::type() const
      {
        return EXP_OPERATORDEFEXPR;
      }

      FancyObject_p OperatorDefExpr::eval(Scope *scope)
      {
        scope->current_class()->def_method(_op_name->name(), _method);
        return nil;
      }

    }
  }
}
