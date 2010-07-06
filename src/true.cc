#include "true.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  True::True() : FancyObject(TrueClass) {}

  FancyObject* True::equal(FancyObject* other) const
  {
    if(IS_TRUE(other))
      return t;
    return nil;
  }

  FancyObject* True::eval(Scope *scope)
  {
    return t;
  }

}
