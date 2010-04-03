#include "includes.h"

ArrayLiteral::ArrayLiteral(expression_node *expr_list)
{
  for(expression_node *tmp = expr_list; tmp != NULL; tmp = tmp->next) {
    this->_expressions.push_back(tmp->expression);
  }
}

ArrayLiteral::ArrayLiteral(list<Expression_p> expressions) :
  _expressions(expressions)
{
}

ArrayLiteral::~ArrayLiteral()
{
}

FancyObject_p ArrayLiteral::eval(Scope *scope)
{
  vector<FancyObject_p> values;
  for(list<Expression_p>::iterator it = this->_expressions.begin();
      it != this->_expressions.end();
      it++) {
    values.push_back((*it)->eval(scope));
  }
  return new Array(values);
}

OBJ_TYPE ArrayLiteral::type() const
{
  return OBJ_ARRAYLITERAL;
}

