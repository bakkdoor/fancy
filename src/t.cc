#include "includes.h"

T::T() : Object(OBJ_T) {}

T::~T() {}

Object_p T::equal(const Object_p other) const
{
  if(other->type() == OBJ_T)
    return t;
  return nil;
}

Object_p T::eval(Scope *scope)
{
  return this;
}

string T::to_s() const
{
  return "true";
}
