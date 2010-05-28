#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      ClassMethodDefExpr::ClassMethodDefExpr(Identifier_p class_name, Identifier_p method_name, Method_p method) :
        _class_name(class_name),
        _method_name(method_name),
        _method(method)
      {
      }

      ClassMethodDefExpr::ClassMethodDefExpr(Identifier_p class_name, list< pair<Identifier_p, Identifier_p> > args_with_name, Method_p method) :
        _class_name(class_name),
        _method_name(0),
        _method(method),
        _method_args(args_with_name)
      {
      }

      EXP_TYPE ClassMethodDefExpr::type() const
      {
        return EXP_METHODDEFEXPR;
      }

      FancyObject_p ClassMethodDefExpr::eval(Scope *scope)
      {
        _method->set_name(method_name());
        scope->get(_class_name->name())->def_singleton_method(method_name(), _method);
        return _method;
      }

      string ClassMethodDefExpr::method_name()
      {
        if(!_method_name) {
          stringstream s;
          list< pair<Identifier_p, Identifier_p> >::iterator it;
    
          for(it = _method_args.begin(); it != _method_args.end(); it++) {
            s << it->first->name() << ":";
          }
    
          return s.str();
        } else {
          return _method_name->name();
        }
      }

    }
  }
}
