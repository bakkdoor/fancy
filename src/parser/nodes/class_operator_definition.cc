#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      ClassOperatorDefExpr::ClassOperatorDefExpr(Identifier_p class_name, Identifier_p op_name, Method_p method) :
        _class_name(class_name),
        _op_name(op_name),
        _method(method)
      {
      }

      OBJ_TYPE ClassOperatorDefExpr::type() const
      {
        return OBJ_OPERATORDEFEXPR;
      }

      FancyObject_p ClassOperatorDefExpr::eval(Scope *scope)
      {
        scope->get(_class_name->name())->def_singleton_method(_op_name->name(), _method);
        return nil;
      }

    }
  }
}
