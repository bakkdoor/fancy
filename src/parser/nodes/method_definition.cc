#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      MethodDefExpr::MethodDefExpr(Identifier_p method_name, Method_p method) :
        method(method), _method_name(method_name)
      {
      }

      MethodDefExpr::MethodDefExpr(list< pair<Identifier_p, Identifier_p> > args_with_name, Method_p method) :
        method_args(args_with_name), method(method), _method_name(0)
      {
      }

      OBJ_TYPE MethodDefExpr::type() const
      {
        return OBJ_METHODDEFEXPR;
      }

      FancyObject_p MethodDefExpr::eval(Scope *scope)
      {
        // set method name explicitly (somehow method names aren't set
        // correctly so this is necessary)
        this->method->set_name(method_name());
        scope->current_class()->def_method(method_name(), this->method);
        return this->method;
      }

      string MethodDefExpr::method_name()
      {
        if(!_method_name) {
          stringstream s;
          list< pair<Identifier_p, Identifier_p> >::iterator it;
    
          for(it = this->method_args.begin(); it != this->method_args.end(); it++) {
            s << it->first->name() << ":";
          }
          _method_name = Identifier::from_string(s.str());
        }

        return _method_name->name();
      }

    }
  }
}
