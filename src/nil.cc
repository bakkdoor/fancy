#include "nil.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  Nil::Nil() : FancyObject(NilClass) {}

  FancyObject* Nil::equal(FancyObject* other) const
  {
    if(IS_NIL(other))
      return t;
    return nil;
  }

  FancyObject* Nil::eval(Scope *scope)
  {
    return nil;
  }

}
