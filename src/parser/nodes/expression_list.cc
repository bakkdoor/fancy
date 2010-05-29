#include "expression_list.h"
#include "../../string.h"
#include "../../bootstrap/core_classes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      ExpressionList::ExpressionList(list<Expression*> expressions) :
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

      FancyObject* ExpressionList::eval(Scope *scope)
      {
        FancyObject* retval = nil;
        list<Expression*>::iterator it;
        for(it = _expressions.begin(); it != _expressions.end(); it++) {
          retval = (*it)->eval(scope);
          // if(IS_RETURNSTATEMENT((*it))) {
          //   return retval;
          // }
        }
        return retval;
      }

      EXP_TYPE ExpressionList::type() const
      {
        return EXP_EXPRLIST;
      }

      unsigned int ExpressionList::size() const
      {
        return _expressions.size();
      }

      string ExpressionList::docstring() const
      {
        if(FancyString* str = dynamic_cast<FancyString*>(_expressions.front())) {
          return str->value();
        }
        return "";
      }

    }
  }
}
