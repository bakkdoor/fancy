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

      string MethodDefExpr::method_name()
      {
        if(!_method_name) {
          stringstream s;
          list< pair<Identifier*, Identifier*> >::iterator it;
    
          for(it = _method_args.begin(); it != _method_args.end(); it++) {
            s << it->first->name() << ":";
          }
          _method_name = Identifier::from_string(s.str());
        }

        return _method_name->name();
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

    }
  }
}
