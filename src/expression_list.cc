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
        _expressions.push_front(tmp->expression);
    }
  }

  ExpressionList::~ExpressionList()
  {
  }

  FancyObject_p ExpressionList::eval(Scope *scope)
  {
    FancyObject_p retval = nil;
    list<Expression_p>::iterator it;
    for(it = _expressions.begin(); it != _expressions.end(); it++) {
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
    return _expressions.size();
  }

  string ExpressionList::docstring() const
  {
    if(String_p str = dynamic_cast<String_p>(_expressions.front())) {
      return str->value();
    }
    return "";
  }
}
