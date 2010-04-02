#include "includes.h"

True::True() : FancyObject(TrueClass) {}

True::~True() {}

NativeObject_p True::equal(const NativeObject_p other) const
{
  if(IS_TRUE(other))
    return t;
  return nil;
}

FancyObject_p True::eval(Scope *scope)
{
  return t;
}

OBJ_TYPE True::type() const
{
  return OBJ_TRUE;
}

string True::to_s() const
{
  return "true";
}
