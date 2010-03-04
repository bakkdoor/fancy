#include "includes.h"

Nil::Nil() : NativeObject(OBJ_NIL) {}

Nil::~Nil() {}

NativeObject_p Nil::equal(const NativeObject_p other) const
{
  if(other->type() == OBJ_NIL)
    return t;
  return nil;
}

FancyObject_p Nil::eval(Scope *scope)
{
  return global_scope->get("nil");;
}

string Nil::to_s() const
{
  return "nil";
}
