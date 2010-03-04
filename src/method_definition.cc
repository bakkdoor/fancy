#include "includes.h"

MethodDefExpr::MethodDefExpr(list< pair<Identifier_p, Identifier_p> > args_with_name, Method_p method) :
  NativeObject(OBJ_METHODDEFEXPR), method_args(args_with_name), method(method)
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

NativeObject_p MethodDefExpr::eval(Scope *scope)
{
  // scope->define(this->method_name, this->method);
  cout << "can't define functions yet!" << endl;
  return nil;
}
