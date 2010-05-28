#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      MethodDefExpr::MethodDefExpr(Identifier_p method_name, Method_p method) :
        _method(method), _method_name(method_name)
      {
      }

      MethodDefExpr::MethodDefExpr(list< pair<Identifier_p, Identifier_p> > args_with_name, Method_p method) :
        _method_args(args_with_name), _method(method), _method_name(0)
      {
      }

      EXP_TYPE MethodDefExpr::type() const
      {
        return EXP_METHODDEFEXPR;
      }

      FancyObject_p MethodDefExpr::eval(Scope *scope)
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
          list< pair<Identifier_p, Identifier_p> >::iterator it;
    
          for(it = _method_args.begin(); it != _method_args.end(); it++) {
            s << it->first->name() << ":";
          }
          _method_name = Identifier::from_string(s.str());
        }

        return _method_name->name();
      }

    }
  }
}
