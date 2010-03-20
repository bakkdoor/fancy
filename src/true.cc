#include "includes.h"

True::True() : NativeObject(OBJ_TRUE) {}

True::~True() {}

NativeObject_p True::equal(const NativeObject_p other) const
{
  if(IS_TRUE(other))
    return t;
  return nil;
}

FancyObject_p True::eval(Scope *scope)
{
  return global_scope->get("true");
}

string True::to_s() const
{
  return "true";
}
