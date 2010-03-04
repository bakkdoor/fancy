#include "includes.h"

ExpressionList::ExpressionList(list<Expression_p> expressions) :
  expressions(expressions)
{
}

ExpressionList::~ExpressionList()
{
}

NativeObject_p ExpressionList::eval(Scope *scope)
{
  NativeObject_p retval = nil;
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
