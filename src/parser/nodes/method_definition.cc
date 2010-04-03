#include "includes.h"

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
  scope->current_class()->def_method(method_name(), this->method);
  return nil;
}

string MethodDefExpr::method_name()
{
  if(!_method_name) {
    stringstream s;
    list< pair<Identifier_p, Identifier_p> >::iterator it;
    
    for(it = this->method_args.begin(); it != this->method_args.end(); it++) {
      s << it->first->name() << ":";
    }
    
    return s.str();
  } else {
    return _method_name->name();
  }
}
