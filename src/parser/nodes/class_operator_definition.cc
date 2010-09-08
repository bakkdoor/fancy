#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

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

      FancyObject* ClassOperatorDefExpr::eval(Scope *scope)
      {
        _class_name->eval(scope)->def_singleton_method(_op_name->name(), _method);
        return _method;
      }

      string ClassOperatorDefExpr::to_sexp() const
      {
        stringstream s;

        s << "['singleton_operator_def, ";
        s << _class_name->to_sexp() << ", ";
        s << _method->to_sexp() << "]";

        return s.str();
      }


      /**
       * PrivateClassOperatorDefExpr
       */

      PrivateClassOperatorDefExpr::PrivateClassOperatorDefExpr(Identifier* class_name, Identifier* op_name, Method* method) :
        ClassOperatorDefExpr(class_name, op_name, method)
      {
      }

      FancyObject* PrivateClassOperatorDefExpr::eval(Scope *scope)
      {
        _class_name->eval(scope)->def_private_singleton_method(_op_name->name(), _method);
        return _method;
      }

      string PrivateClassOperatorDefExpr::to_sexp() const
      {
        return "['private, " + ClassOperatorDefExpr::to_sexp() + "]";
      }

      /**
       * ProtectedClassOperatorDefExpr
       */

      ProtectedClassOperatorDefExpr::ProtectedClassOperatorDefExpr(Identifier* class_name, Identifier* op_name, Method* method) :
        ClassOperatorDefExpr(class_name, op_name, method)
      {
      }

      FancyObject* ProtectedClassOperatorDefExpr::eval(Scope *scope)
      {
        _class_name->eval(scope)->def_protected_singleton_method(_op_name->name(), _method);
        return _method;
      }

      string ProtectedClassOperatorDefExpr::to_sexp() const
      {
        return "['protected, " + ClassOperatorDefExpr::to_sexp() + "]";
      }
    }
  }
}
