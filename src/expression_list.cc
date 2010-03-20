#include "includes.h"

ExpressionList::ExpressionList(list<Expression_p> expressions) :
  expressions(expressions)
{
}

ExpressionList::ExpressionList(expression_node *list)
{
  expression_node *tmp;
  for(tmp = list; tmp != 0; tmp = tmp->next) {
    if(tmp->expression)
      this->expressions.push_back(tmp->expression);
  }
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

unsigned int ExpressionList::size() const
{
  return this->expressions.size();
}
