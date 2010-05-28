#include "includes.h"

namespace fancy {

  True::True() : FancyObject(TrueClass) {}

  True::~True() {}

  FancyObject_p True::equal(const FancyObject_p other) const
  {
    if(IS_TRUE(other))
      return t;
    return nil;
  }

  FancyObject_p True::eval(Scope *scope)
  {
    return t;
  }

  EXP_TYPE True::type() const
  {
    return EXP_TRUE;
  }

  string True::to_s() const
  {
    return "true";
  }

}
