#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

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

      string ExpressionList::to_sexp() const
      {
        stringstream s;

        s << "['exp_list, [";

        int size = _expressions.size();
        int count = 1;
        list<Expression*>::const_iterator it;
        for(it = _expressions.begin(); it != _expressions.end(); it++) {
          s << (*it)->to_sexp();
          if(count < size) {
            s << ", ";
          }
          count++;
        }

        s << "]]";

        return s.str();
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
