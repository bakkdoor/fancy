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

      FancyObject* OperatorDefExpr::eval(Scope *scope)
      {
        scope->current_class()->def_method(_op_name->name(), _method);
        return _method;
      }


      /**
       * PrivateOperatorDefExpr
       */

      PrivateOperatorDefExpr::PrivateOperatorDefExpr(Identifier* op_name, Method* method) :
        OperatorDefExpr(op_name, method)
      {
      }

      FancyObject* PrivateOperatorDefExpr::eval(Scope *scope)
      {
        scope->current_class()->def_private_method(_op_name->name(), _method);
        return _method;
      }


      /**
       * ProtectedOperatorDefExpr
       */

      ProtectedOperatorDefExpr::ProtectedOperatorDefExpr(Identifier* op_name, Method* method) :
        OperatorDefExpr(op_name, method)
      {
      }

      FancyObject* ProtectedOperatorDefExpr::eval(Scope *scope)
      {
        scope->current_class()->def_protected_method(_op_name->name(), _method);
        return _method;
      }

    }
  }
}
