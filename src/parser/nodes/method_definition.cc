#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

#include <sstream>

#include "method_definition.h"
#include "../../class.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      MethodDefExpr::MethodDefExpr(Identifier* method_name, Method* method) :
        _method(method), _method_name(method_name)
      {
      }

      MethodDefExpr::MethodDefExpr(list< pair<Identifier*, Identifier*> > args_with_name, Method* method) :
        _method_args(args_with_name), _method(method), _method_name(0)
      {
      }

      FancyObject* MethodDefExpr::eval(Scope *scope)
      {
        // set method name explicitly (somehow method names aren't set
        // correctly so this is necessary)
        _method->set_name(method_name());
        scope->current_class()->def_method(method_name(), _method);
        return _method;
      }

      string MethodDefExpr::to_sexp() const
      {
        stringstream s;
        s << "['method_def, ";
        // insert method
        _method->set_name(method_name());
        s << _method->to_sexp() << "]";
        return s.str();
      }

      string MethodDefExpr::method_name() const
      {
        if(!_method_name) {
          stringstream s;
          list< pair<Identifier*, Identifier*> >::const_iterator it;
          for(it = _method_args.begin(); it != _method_args.end(); it++) {
            s << it->first->name() << ":";
          }

          return s.str();
        } else {
          return _method_name->name();
        }
      }


      /**
       * PrivateMethodDefExpr
       */

      PrivateMethodDefExpr::PrivateMethodDefExpr(Identifier* method_name, Method* method) :
        MethodDefExpr(method_name, method)
      {
      }

      PrivateMethodDefExpr::PrivateMethodDefExpr(list< pair<Identifier*, Identifier*> > args_with_name, Method* method) :
        MethodDefExpr(args_with_name, method)
      {
      }

      FancyObject* PrivateMethodDefExpr::eval(Scope *scope)
      {
        _method->set_name(method_name());
        scope->current_class()->def_private_method(method_name(), _method);
        return _method;
      }

      string PrivateMethodDefExpr::to_sexp() const
      {
        return "['private, " + MethodDefExpr::to_sexp() + "]";
      }

      /**
       * ProtectedMethodDefExpr
       */

      ProtectedMethodDefExpr::ProtectedMethodDefExpr(Identifier* method_name, Method* method) :
        MethodDefExpr(method_name, method)
      {
      }

      ProtectedMethodDefExpr::ProtectedMethodDefExpr(list< pair<Identifier*, Identifier*> > args_with_name, Method* method) :
        MethodDefExpr(args_with_name, method)
      {
      }

      FancyObject* ProtectedMethodDefExpr::eval(Scope *scope)
      {
        _method->set_name(method_name());
        scope->current_class()->def_protected_method(method_name(), _method);
        return _method;
      }

      string ProtectedMethodDefExpr::to_sexp() const
      {
        return "['protected, " + MethodDefExpr::to_sexp() + "]";
      }
    }
  }
}
