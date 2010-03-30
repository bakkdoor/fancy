#include "includes.h"

MethodDefExpr::MethodDefExpr(Identifier_p method_name, Method_p method) :
  NativeObject(OBJ_METHODDEFEXPR), method(method), _method_name(method_name)
{
}

MethodDefExpr::MethodDefExpr(list< pair<Identifier_p, Identifier_p> > args_with_name, Method_p method) :
  NativeObject(OBJ_METHODDEFEXPR), method_args(args_with_name), method(method), _method_name(0)
{
}

NativeObject_p MethodDefExpr::equal(const NativeObject_p other) const
{
  return nil;
}

string MethodDefExpr::to_s() const
{
  return "<method_def>";
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
