#include "includes.h"

namespace fancy {

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

  EXP_TYPE Nil::type() const
  {
    return EXP_NIL;
  }

  string Nil::to_s() const
  {
    return "nil";
  }

}
