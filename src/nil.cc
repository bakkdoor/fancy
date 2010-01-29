#include "includes.h"

Nil::Nil() : Object(OBJ_NIL) {}

Nil::~Nil() {}

Object_p Nil::equal(const Object_p other) const
{
  if(other->type() == OBJ_NIL)
    return t;
  return nil;
}

Object_p Nil::eval(Scope *scope)
{
  return this;
}

string Nil::to_s() const
{
  return "nil";
}
