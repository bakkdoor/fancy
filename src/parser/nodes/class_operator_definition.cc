#include "class_operator_definition.h"
#include "../../bootstrap/core_classes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      ClassOperatorDefExpr::ClassOperatorDefExpr(Identifier* class_name, Identifier* op_name, Method* method) :
        _class_name(class_name),
        _op_name(op_name),
        _method(method)
      {
      }

      EXP_TYPE ClassOperatorDefExpr::type() const
      {
        return EXP_OPERATORDEFEXPR;
      }

      FancyObject* ClassOperatorDefExpr::eval(Scope *scope)
      {
        scope->get(_class_name->name())->def_singleton_method(_op_name->name(), _method);
        return nil;
      }

    }
  }
}
