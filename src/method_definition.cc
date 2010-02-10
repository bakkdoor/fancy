#include "includes.h"

MethodDefExpr::MethodDefExpr(list< pair<Identifier_p, Identifier_p> > args_with_name, Method_p method) :
  Object(OBJ_METHODDEFEXPR), method_args(args_with_name), method(method)
{
}

Object_p MethodDefExpr::equal(const Object_p other) const
{
  return nil;
}

string MethodDefExpr::to_s() const
{
  return "<method_def>";
}

Object_p MethodDefExpr::eval(Scope *scope)
{
  // scope->define(this->method_name, this->method);
  cout << "can't define functions yet!" << endl;
  return nil;
}
