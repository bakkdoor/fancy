#ifndef _ASSIGNMENT_H_
#define _ASSIGNMENT_H_

#include "../../expression.h"
#include "expression_list.h"
#include "identifier.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      /**
       * Assignment expression class.
       * Used in the parser. 
       * When evaluated, sets the value of an identifier within the current
       * scope.
       */
      class AssignmentExpr : public Expression
      {
      public:
        AssignmentExpr(Identifier* identifier, Expression* value_expr);
        ~AssignmentExpr();
  
        virtual EXP_TYPE type() const;
        virtual FancyObject* eval(Scope *scope);

      private:
        Identifier*  _identifier;
        Expression*  _value_expr;
      };

    }
  }
}

#endif /* _ASSIGNMENT_H_ */
