#include "operator_definition.h"
#include "../../class.h"
#include "../../bootstrap/core_classes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      OperatorDefExpr::OperatorDefExpr(Identifier* op_name, Method* method) :
        _op_name(op_name),
        _method(method)
      {
      }

      EXP_TYPE OperatorDefExpr::type() const
      {
        return EXP_OPERATORDEFEXPR;
      }

      FancyObject* OperatorDefExpr::eval(Scope *scope)
      {
        scope->current_class()->def_method(_op_name->name(), _method);
        return nil;
      }

    }
  }
}
