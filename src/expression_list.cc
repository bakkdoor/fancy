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
      this->expressions.push_front(tmp->expression);
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
    if(IS_RETURNSTATEMENT((*it))) {
      return retval;
    }
  }
  return retval;
}

OBJ_TYPE ExpressionList::type() const
{
  return OBJ_EXPRLIST;
}

unsigned int ExpressionList::size() const
{
  return this->expressions.size();
}
