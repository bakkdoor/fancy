#include "includes.h"

namespace fancy {

  ExpressionList::ExpressionList(list<Expression_p> expressions) :
    _expressions(expressions)
  {
  }

  ExpressionList::ExpressionList(expression_node *list)
  {
    expression_node *tmp;
    for(tmp = list; tmp != 0; tmp = tmp->next) {
      if(tmp->expression)
        this->_expressions.push_front(tmp->expression);
    }
  }

  ExpressionList::~ExpressionList()
  {
  }

  FancyObject_p ExpressionList::eval(Scope *scope)
  {
    FancyObject_p retval = nil;
    list<Expression_p>::iterator it;
    for(it = this->_expressions.begin(); it != this->_expressions.end(); it++) {
      retval = (*it)->eval(scope);
      // if(IS_RETURNSTATEMENT((*it))) {
      //   return retval;
      // }
    }
    return retval;
  }

  OBJ_TYPE ExpressionList::type() const
  {
    return OBJ_EXPRLIST;
  }

  unsigned int ExpressionList::size() const
  {
    return this->_expressions.size();
  }

  string ExpressionList::docstring() const
  {
    if(String_p str = dynamic_cast<String_p>(this->_expressions.front())) {
      return str->value();
    }
    return "";
  }
}
