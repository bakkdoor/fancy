#include "includes.h"

ArrayLiteral::ArrayLiteral(expression_node *expr_list) :
  NativeObject(OBJ_ARRAYLITERAL)
{
  for(expression_node *tmp = expr_list; tmp != NULL; tmp = tmp->next) {
    this->_expressions.push_back(tmp->expression);
  }
}

ArrayLiteral::ArrayLiteral(list<Expression_p> expressions) :
  NativeObject(OBJ_ARRAYLITERAL),
  _expressions(expressions)
{
}

ArrayLiteral::~ArrayLiteral()
{
}

NativeObject_p ArrayLiteral::equal(const NativeObject_p other) const
{
  return nil;
}

FancyObject_p ArrayLiteral::eval(Scope *scope)
{
  vector<FancyObject_p> values;
  for(list<Expression_p>::iterator it = this->_expressions.begin();
      it != this->_expressions.end();
      it++) {
    values.push_back((*it)->eval(scope));
  }
  return ArrayClass->create_instance(new Array(values));
}

string ArrayLiteral::to_s() const
{
  return "<ArrayLiteral>";
}

