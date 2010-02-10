#include "includes.h"

ExpressionList::ExpressionList(Array_p expressions) :
  expressions(expressions)
{
}

ExpressionList::~ExpressionList()
{
}

Object_p ExpressionList::eval(Scope *scope)
{
  assert(this->expressions);
  for(int i = 0; i < this->expressions->size(); i++) {
    this->expressions->at(i)->eval(scope);
  }
}

Object_p ExpressionList::equal(const Object_p other) const
{
  return nil;
}
