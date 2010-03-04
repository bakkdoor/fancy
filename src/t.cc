#include "includes.h"

T::T() : NativeObject(OBJ_T) {}

T::~T() {}

NativeObject_p T::equal(const NativeObject_p other) const
{
  if(other->type() == OBJ_T)
    return t;
  return nil;
}

FancyObject_p T::eval(Scope *scope)
{
  return global_scope->get("t");
}

string T::to_s() const
{
  return "true";
}
