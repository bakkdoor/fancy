#include "includes.h"

ExpressionList::ExpressionList(list<Expression_p> expressions) :
  expressions(expressions)
{
}

ExpressionList::~ExpressionList()
{
}

FancyObject_p ExpressionList::eval(Scope *scope)
{
  FancyObject_p retval = nil;
  list<Expression_p>::iterator it;
  for(it = this->expressions.begin(); it != this->expressions.end(); it++) {
    retval = (*it)->eval(scope);
  }
  return retval;
}

NativeObject_p ExpressionList::equal(const NativeObject_p other) const
{
  return nil;
}
