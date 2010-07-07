#ifndef _ARRAY_LITERAL_H_
#define _ARRAY_LITERAL_H_

#include "../../expression.h"
#include "../../array.h"
#include "expression_list.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      /**
       * ArrayLiteral class for Array literal values.
       * When evaluated, returns an instance of ArrayClass.
       * Only used within parser.
       */
      class ArrayLiteral : public Expression
      {
      public:
        ArrayLiteral(expression_node *expr_list);
        virtual ~ArrayLiteral() {}

        virtual FancyObject* eval(Scope *scope);
        virtual EXP_TYPE type() const { return EXP_ARRAYLITERAL; }

      private:
        list<Expression*> _expressions;
      };

    }
  }
}
#endif /* _ARRAY_LITERAL_H_ */
