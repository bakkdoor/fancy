#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

#include "array_literal.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      ArrayLiteral::ArrayLiteral(expression_node *expr_list)
      {
        for(expression_node *tmp = expr_list; tmp != NULL; tmp = tmp->next) {
          _expressions.push_front(tmp->expression);
        }
      }

      FancyObject* ArrayLiteral::eval(Scope *scope)
      {
        vector<FancyObject*> values;
        for(list<Expression*>::iterator it = _expressions.begin();
            it != _expressions.end();
            it++) {
          values.push_back((*it)->eval(scope));
        }
        return new Array(values);
      }

    }
  }
}
