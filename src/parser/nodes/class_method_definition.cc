#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

#include <sstream>
#include "class_method_definition.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      ClassMethodDefExpr::ClassMethodDefExpr(Identifier* class_name, Identifier* method_name, Method* method) :
        _class_name(class_name),
        _method_name(method_name),
        _method(method)
      {
      }

      ClassMethodDefExpr::ClassMethodDefExpr(Identifier* class_name, list< pair<Identifier*, Identifier*> > args_with_name, Method* method) :
        _class_name(class_name),
        _method_name(0),
        _method(method),
        _method_args(args_with_name)
      {
      }

      FancyObject* ClassMethodDefExpr::eval(Scope *scope)
      {
        _method->set_name(method_name());
        _class_name->eval(scope)->def_singleton_method(method_name(), _method);
        return _method;
      }

      string ClassMethodDefExpr::method_name()
      {
        if(!_method_name) {
          stringstream s;
          list< pair<Identifier*, Identifier*> >::iterator it;

          for(it = _method_args.begin(); it != _method_args.end(); it++) {
            s << it->first->name() << ":";
          }

          return s.str();
        } else {
          return _method_name->name();
        }
      }


      /**
       * PrivateClassMethodDefExpr
       */

      PrivateClassMethodDefExpr::PrivateClassMethodDefExpr(Identifier* class_name, Identifier* method_name, Method* method) :
        ClassMethodDefExpr(class_name, method_name, method)
      {
      }

      PrivateClassMethodDefExpr::PrivateClassMethodDefExpr(Identifier* class_name, list< pair<Identifier*, Identifier*> > args_with_name, Method* method) :
        ClassMethodDefExpr(class_name, args_with_name, method)
      {
      }

      FancyObject* PrivateClassMethodDefExpr::eval(Scope *scope)
      {
        _method->set_name(method_name());
        _class_name->eval(scope)->def_private_singleton_method(method_name(), _method);
        return _method;
      }


      /**
       * ProtectedClassMethodDefExpr
       */

      ProtectedClassMethodDefExpr::ProtectedClassMethodDefExpr(Identifier* class_name, Identifier* method_name, Method* method) :
        ClassMethodDefExpr(class_name, method_name, method)
      {
      }

      ProtectedClassMethodDefExpr::ProtectedClassMethodDefExpr(Identifier* class_name, list< pair<Identifier*, Identifier*> > args_with_name, Method* method) :
        ClassMethodDefExpr(class_name, args_with_name, method)
      {
      }

      FancyObject* ProtectedClassMethodDefExpr::eval(Scope *scope)
      {
        _method->set_name(method_name());
        _class_name->eval(scope)->def_protected_singleton_method(method_name(), _method);
        return _method;
      }

    }
  }
}
