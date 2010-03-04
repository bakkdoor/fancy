#include "includes.h"

T::T() : NativeObject(OBJ_T) {}

T::~T() {}

NativeObject_p T::equal(const NativeObject_p other) const
{
  if(other->type() == OBJ_T)
    return t;
  return nil;
}

NativeObject_p T::eval(Scope *scope)
{
  return this;
}

string T::to_s() const
{
  return "true";
}
