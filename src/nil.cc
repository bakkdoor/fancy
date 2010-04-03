#include "includes.h"

Nil::Nil() : FancyObject(NilClass) {}

Nil::~Nil() {}

FancyObject_p Nil::equal(const FancyObject_p other) const
{
  if(IS_NIL(other))
    return t;
  return nil;
}

FancyObject_p Nil::eval(Scope *scope)
{
  return nil;
}

OBJ_TYPE Nil::type() const
{
  return OBJ_NIL;
}

string Nil::to_s() const
{
  return "nil";
}
