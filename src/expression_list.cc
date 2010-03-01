#include "includes.h"

ExpressionList::ExpressionList(list<Expression_p> expressions) :
  expressions(expressions)
{
}

ExpressionList::~ExpressionList()
{
}

Object_p ExpressionList::eval(Scope *scope)
{
  Object_p retval = nil;
  list<Expression_p>::iterator it;
  for(it = this->expressions.begin(); it != this->expressions.end(); it++) {
    retval = (*it)->eval(scope);
  }
  return retval;
}

Object_p ExpressionList::equal(const Object_p other) const
{
  return nil;
}
